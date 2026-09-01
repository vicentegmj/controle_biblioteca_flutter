import 'package:controle_biblioteca/core/database/database.dart';
import 'package:controle_biblioteca/core/utils/domain_exception.dart';
import 'package:controle_biblioteca/repositories/aluno_repository.dart';
import 'package:controle_biblioteca/repositories/configuracao_repository.dart';
import 'package:controle_biblioteca/repositories/emprestimo_repository.dart';
import 'package:controle_biblioteca/repositories/exemplar_repository.dart';
import 'package:controle_biblioteca/repositories/livro_repository.dart';
import 'package:controle_biblioteca/repositories/turma_repository.dart';
import 'package:controle_biblioteca/services/emprestimo_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ambiente de teste com um banco em memória e todos os repositórios/serviço
/// já instanciados, além de helpers para criar rapidamente turma, aluno,
/// livro e exemplar de teste.
class _TestEnv {
  _TestEnv._(this.db)
      : turmaRepository = TurmaRepository(db),
        alunoRepository = AlunoRepository(db),
        livroRepository = LivroRepository(db),
        exemplarRepository = ExemplarRepository(db),
        emprestimoRepository = EmprestimoRepository(db),
        configuracaoRepository = ConfiguracaoRepository(db) {
    service = EmprestimoService(
      emprestimoRepository: emprestimoRepository,
      alunoRepository: alunoRepository,
      exemplarRepository: exemplarRepository,
      configuracaoRepository: configuracaoRepository,
    );
  }

  factory _TestEnv.create() => _TestEnv._(AppDatabase.forTesting());

  final AppDatabase db;
  final TurmaRepository turmaRepository;
  final AlunoRepository alunoRepository;
  final LivroRepository livroRepository;
  final ExemplarRepository exemplarRepository;
  final EmprestimoRepository emprestimoRepository;
  final ConfiguracaoRepository configuracaoRepository;
  late final EmprestimoService service;
  int _proximoCodigo = 0;

  Future<int> criarTurma() => turmaRepository.create(
        TurmasCompanion.insert(
          nome: '6º Ano A',
          serie: '6º Ano',
          turno: 'Matutino',
          anoLetivo: 2026,
        ),
      );

  Future<int> criarAluno({int? turmaId, bool ativo = true}) async {
    final tId = turmaId ?? await criarTurma();
    final id = await alunoRepository.create(
      AlunosCompanion.insert(nome: 'Aluno Teste', turmaId: tId),
    );
    if (!ativo) {
      await alunoRepository.setAtivo(id, false);
    }
    return id;
  }

  Future<int> criarLivro() => livroRepository.create(
        LivrosCompanion.insert(titulo: 'Livro Teste', autor: 'Autor Teste'),
      );

  Future<int> criarExemplar({int? livroId, String? codigo, bool ativo = true}) async {
    final lId = livroId ?? await criarLivro();
    final id = await exemplarRepository.create(
      ExemplaresCompanion.insert(
        livroId: lId,
        codigo: codigo ?? 'EX${_proximoCodigo++}',
      ),
    );
    if (!ativo) {
      await exemplarRepository.setAtivo(id, false);
    }
    return id;
  }

  Future<void> close() => db.close();
}

void main() {
  late _TestEnv env;

  setUp(() => env = _TestEnv.create());
  tearDown(() => env.close());

  group('Regra 1: exemplar não pode ter dois empréstimos abertos', () {
    test('bloqueia novo empréstimo do mesmo exemplar', () async {
      final alunoId = await env.criarAluno();
      final exemplarId = await env.criarExemplar();

      await env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId],
      );

      final outroAluno = await env.criarAluno();
      expect(
        () => env.service.registrarEmprestimo(
          alunoId: outroAluno,
          dataEmprestimo: DateTime.now(),
          dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
          exemplarIds: [exemplarId],
        ),
        throwsA(isA<DomainException>()),
      );
    });

    test('permite emprestar novamente após devolução', () async {
      final alunoId = await env.criarAluno();
      final exemplarId = await env.criarExemplar();

      final emprestimoId = await env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId],
      );
      final itens = await env.emprestimoRepository.getItensDoEmprestimo(emprestimoId);
      await env.service.devolverItem(itens.single.id);

      final novoEmprestimoId = await env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId],
      );
      expect(novoEmprestimoId, isPositive);
    });
  });

  test('Regra 3: aluno inativo não pode realizar novo empréstimo', () async {
    final alunoId = await env.criarAluno(ativo: false);
    final exemplarId = await env.criarExemplar();

    expect(
      () => env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId],
      ),
      throwsA(isA<DomainException>()),
    );
  });

  test('Regra 4: exemplar inativo não pode ser emprestado', () async {
    final alunoId = await env.criarAluno();
    final exemplarId = await env.criarExemplar(ativo: false);

    expect(
      () => env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId],
      ),
      throwsA(isA<DomainException>()),
    );
  });

  test('Devolução correta marca item e encerra o empréstimo de item único', () async {
    final alunoId = await env.criarAluno();
    final exemplarId = await env.criarExemplar();

    final emprestimoId = await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now(),
      dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
      exemplarIds: [exemplarId],
    );
    final itens = await env.emprestimoRepository.getItensDoEmprestimo(emprestimoId);
    await env.service.devolverItem(itens.single.id);

    final emprestimo = await env.emprestimoRepository.getEmprestimoById(emprestimoId);
    expect(emprestimo!.status, StatusEmprestimo.devolvido);

    final itemAtualizado =
        (await env.emprestimoRepository.getItensDoEmprestimo(emprestimoId)).single;
    expect(itemAtualizado.dataDevolucao, isNotNull);
  });

  test('Devolução parcial mantém o empréstimo aberto até todos os itens voltarem', () async {
    final alunoId = await env.criarAluno();
    final exemplarA = await env.criarExemplar();
    final exemplarB = await env.criarExemplar();

    final emprestimoId = await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now(),
      dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
      exemplarIds: [exemplarA, exemplarB],
    );
    final itens = await env.emprestimoRepository.getItensDoEmprestimo(emprestimoId);

    await env.service.devolverItem(itens.first.id);
    var emprestimo = await env.emprestimoRepository.getEmprestimoById(emprestimoId);
    expect(emprestimo!.status, StatusEmprestimo.aberto);

    await env.service.devolverItem(itens.last.id);
    emprestimo = await env.emprestimoRepository.getEmprestimoById(emprestimoId);
    expect(emprestimo!.status, StatusEmprestimo.devolvido);
  });

  test('Identificação de atraso considera apenas itens em aberto vencidos', () async {
    final alunoId = await env.criarAluno();
    final exemplarId = await env.criarExemplar();

    await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now().subtract(const Duration(days: 10)),
      dataPrevistaDevolucao: DateTime.now().subtract(const Duration(days: 3)),
      exemplarIds: [exemplarId],
    );

    final abertos = await env.emprestimoRepository.getItensAbertos();
    expect(abertos.single.atrasado, isTrue);
    expect(abertos.single.diasAtraso, greaterThanOrEqualTo(3));
  });

  test('Quantidade máxima de empréstimos simultâneos por aluno é respeitada', () async {
    await env.configuracaoRepository.setValor('max_emprestimos_simultaneos', '2');
    final alunoId = await env.criarAluno();
    final e1 = await env.criarExemplar();
    final e2 = await env.criarExemplar();
    final e3 = await env.criarExemplar();

    await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now(),
      dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
      exemplarIds: [e1, e2],
    );

    expect(
      () => env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [e3],
      ),
      throwsA(isA<DomainException>()),
    );
  });

  test('Bloqueio por atraso impede novo empréstimo quando configurado', () async {
    await env.configuracaoRepository.setValor('bloquear_emprestimo_se_atraso', 'true');
    final alunoId = await env.criarAluno();
    final exemplarAtrasado = await env.criarExemplar();
    final novoExemplar = await env.criarExemplar();

    await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now().subtract(const Duration(days: 20)),
      dataPrevistaDevolucao: DateTime.now().subtract(const Duration(days: 10)),
      exemplarIds: [exemplarAtrasado],
    );

    expect(
      () => env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [novoExemplar],
      ),
      throwsA(isA<DomainException>()),
    );
  });

  test('Bloqueio por atraso não se aplica quando configuração está desativada', () async {
    await env.configuracaoRepository.setValor('bloquear_emprestimo_se_atraso', 'false');
    final alunoId = await env.criarAluno();
    final exemplarAtrasado = await env.criarExemplar();
    final novoExemplar = await env.criarExemplar();

    await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now().subtract(const Duration(days: 20)),
      dataPrevistaDevolucao: DateTime.now().subtract(const Duration(days: 10)),
      exemplarIds: [exemplarAtrasado],
    );

    final novoEmprestimoId = await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now(),
      dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
      exemplarIds: [novoExemplar],
    );
    expect(novoEmprestimoId, isPositive);
  });

  group('Cancelamento', () {
    test('cancela empréstimo sem itens devolvidos', () async {
      final alunoId = await env.criarAluno();
      final exemplarId = await env.criarExemplar();

      final emprestimoId = await env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId],
      );
      await env.service.cancelarEmprestimo(emprestimoId);

      final emprestimo = await env.emprestimoRepository.getEmprestimoById(emprestimoId);
      expect(emprestimo!.status, StatusEmprestimo.cancelado);

      // O exemplar volta a ficar disponível para novo empréstimo.
      final outroAluno = await env.criarAluno();
      final novoEmprestimoId = await env.service.registrarEmprestimo(
        alunoId: outroAluno,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId],
      );
      expect(novoEmprestimoId, isPositive);
    });

    test('não cancela empréstimo com item já devolvido', () async {
      final alunoId = await env.criarAluno();
      final exemplarId = await env.criarExemplar();

      final emprestimoId = await env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId],
      );
      final itens = await env.emprestimoRepository.getItensDoEmprestimo(emprestimoId);
      await env.service.devolverItem(itens.single.id);

      expect(
        () => env.service.cancelarEmprestimo(emprestimoId),
        throwsA(isA<DomainException>()),
      );
    });
  });

  test('Histórico é preservado após devolução e cancelamento (nada é apagado)', () async {
    final alunoId = await env.criarAluno();
    final exemplarDevolvido = await env.criarExemplar();
    final exemplarCancelado = await env.criarExemplar();

    final emprestimo1 = await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now(),
      dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
      exemplarIds: [exemplarDevolvido],
    );
    final itens1 = await env.emprestimoRepository.getItensDoEmprestimo(emprestimo1);
    await env.service.devolverItem(itens1.single.id);

    final emprestimo2 = await env.service.registrarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: DateTime.now(),
      dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
      exemplarIds: [exemplarCancelado],
    );
    await env.service.cancelarEmprestimo(emprestimo2);

    final historico = await env.emprestimoRepository.getHistoricoAluno(alunoId);
    expect(historico.length, 2);
    expect(historico.map((h) => h.emprestimo.id), containsAll([emprestimo1, emprestimo2]));
  });

  test('Não permite emprestar o mesmo exemplar duas vezes no mesmo empréstimo', () async {
    final alunoId = await env.criarAluno();
    final exemplarId = await env.criarExemplar();

    expect(
      () => env.service.registrarEmprestimo(
        alunoId: alunoId,
        dataEmprestimo: DateTime.now(),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 7)),
        exemplarIds: [exemplarId, exemplarId],
      ),
      throwsA(isA<DomainException>()),
    );
  });
}
