import 'package:controle_biblioteca/core/database/database.dart';
import 'package:controle_biblioteca/core/utils/domain_exception.dart';
import 'package:controle_biblioteca/models/emprestimo_extensions.dart';
import 'package:controle_biblioteca/repositories/configuracao_repository.dart';
import 'package:controle_biblioteca/repositories/emprestimo_repository.dart';
import 'package:controle_biblioteca/services/emprestimo_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late EmprestimoRepository repository;
  late ConfiguracaoRepository configuracaoRepository;
  late EmprestimoService service;

  setUp(() {
    db = AppDatabase.forTesting();
    repository = EmprestimoRepository(db);
    configuracaoRepository = ConfiguracaoRepository(db);
    service = EmprestimoService(
      emprestimoRepository: repository,
      configuracaoRepository: configuracaoRepository,
    );
  });

  tearDown(() => db.close());

  Future<int> registrar({
    String alunoNome = 'João Silva',
    int serie = 6,
    String turmaLetra = 'A',
    String livroTitulo = 'O Pequeno Príncipe',
    DateTime? dataEmprestimo,
    DateTime? dataPrevistaDevolucao,
    String? observacao,
  }) {
    final emprestimo = dataEmprestimo ?? DateTime.now();
    return service.registrarEmprestimo(
      alunoNome: alunoNome,
      serie: serie,
      turmaLetra: turmaLetra,
      livroTitulo: livroTitulo,
      dataEmprestimo: emprestimo,
      dataPrevistaDevolucao:
          dataPrevistaDevolucao ?? emprestimo.add(const Duration(days: 7)),
      observacao: observacao,
    );
  }

  group('Validação de campos obrigatórios', () {
    test('rejeita aluno em branco', () {
      expect(() => registrar(alunoNome: '   '), throwsA(isA<DomainException>()));
    });

    test('rejeita livro em branco', () {
      expect(() => registrar(livroTitulo: ''), throwsA(isA<DomainException>()));
    });

    test('rejeita série fora do intervalo 1-9', () {
      expect(() => registrar(serie: 0), throwsA(isA<DomainException>()));
      expect(() => registrar(serie: 10), throwsA(isA<DomainException>()));
    });

    test('rejeita letra de turma inválida', () {
      expect(() => registrar(turmaLetra: '1'), throwsA(isA<DomainException>()));
      expect(() => registrar(turmaLetra: 'AB'), throwsA(isA<DomainException>()));
      expect(() => registrar(turmaLetra: ''), throwsA(isA<DomainException>()));
    });

    test('normaliza a letra da turma para maiúscula', () async {
      final id = await registrar(turmaLetra: 'a');
      final emprestimo = await repository.getById(id);
      expect(emprestimo!.turmaLetra, 'A');
    });

    test('normaliza nome do aluno e título do livro para Title Case', () async {
      final id = await registrar(
        alunoNome: 'vicente  garcia',
        livroTitulo: 'o PEQUENO príncipe',
      );
      final emprestimo = await repository.getById(id);
      expect(emprestimo!.alunoNome, 'Vicente Garcia');
      expect(emprestimo.livroTitulo, 'O Pequeno Príncipe');
    });

    test('rejeita data prevista anterior à data do empréstimo', () {
      final hoje = DateTime(2026, 9, 10);
      expect(
        () => registrar(
          dataEmprestimo: hoje,
          dataPrevistaDevolucao: hoje.subtract(const Duration(days: 1)),
        ),
        throwsA(isA<DomainException>()),
      );
    });
  });

  test('Ano letivo é derivado automaticamente da data do empréstimo', () async {
    final id = await registrar(dataEmprestimo: DateTime(2027, 2, 15));
    final emprestimo = await repository.getById(id);
    expect(emprestimo!.anoLetivo, 2027);
  });

  test('Data prevista é calculada a partir do prazo padrão configurado', () async {
    await configuracaoRepository.setValor('prazo_padrao_dias', '10');
    final prevista = await service.calcularDataPrevista(DateTime(2026, 9, 1));
    expect(prevista, DateTime(2026, 9, 11));
  });

  test('Não é necessário cadastro prévio: qualquer nome/turma/livro é aceito', () async {
    final id = await registrar(
      alunoNome: 'Pedro Henrique',
      serie: 7,
      turmaLetra: 'B',
      livroTitulo: 'Dom Casmurro',
    );
    expect(id, isPositive);
  });

  group('Devolução', () {
    test('marca o empréstimo como devolvido e preenche a data', () async {
      final id = await registrar();
      await service.devolver(id);

      final emprestimo = await repository.getById(id);
      expect(emprestimo!.status, StatusEmprestimo.devolvido);
      expect(emprestimo.dataDevolucao, isNotNull);
    });

    test('não devolve um empréstimo que já foi devolvido', () async {
      final id = await registrar();
      await service.devolver(id);
      expect(() => service.devolver(id), throwsA(isA<DomainException>()));
    });

    test('não devolve um empréstimo cancelado', () async {
      final id = await registrar();
      await service.cancelar(id);
      expect(() => service.devolver(id), throwsA(isA<DomainException>()));
    });
  });

  group('Cancelamento', () {
    test('cancela um empréstimo em aberto', () async {
      final id = await registrar();
      await service.cancelar(id);
      final emprestimo = await repository.getById(id);
      expect(emprestimo!.status, StatusEmprestimo.cancelado);
    });

    test('não cancela um empréstimo já devolvido', () async {
      final id = await registrar();
      await service.devolver(id);
      expect(() => service.cancelar(id), throwsA(isA<DomainException>()));
    });
  });

  test('Identificação de atraso é calculada, não armazenada', () async {
    final ontem = DateTime.now().subtract(const Duration(days: 1));
    final id = await registrar(
      dataEmprestimo: DateTime.now().subtract(const Duration(days: 8)),
      dataPrevistaDevolucao: ontem,
    );
    final emprestimo = await repository.getById(id);
    expect(emprestimo!.atrasado, isTrue);
    expect(emprestimo.diasAtraso, greaterThanOrEqualTo(1));

    final abertos = await repository.getAbertos();
    expect(abertos.any((e) => e.id == id), isTrue);
  });

  test('Histórico é preservado após devolução e cancelamento (nada é apagado)', () async {
    final devolvidoId = await registrar(alunoNome: 'Maria Fernanda');
    await service.devolver(devolvidoId);

    final canceladoId = await registrar(alunoNome: 'Maria Fernanda');
    await service.cancelar(canceladoId);

    final historico = await repository.watchTodos().first;
    expect(historico.map((e) => e.id), containsAll([devolvidoId, canceladoId]));
  });

  group('Sugestões pelo histórico', () {
    test('retorna nomes distintos, sem diferenciar maiúsculas/minúsculas', () async {
      await registrar(alunoNome: 'João Silva');
      await registrar(alunoNome: 'João Silva');
      await registrar(alunoNome: 'João Pedro');
      await registrar(alunoNome: 'Maria Fernanda');

      final sugestoes = await repository.sugerirAlunos('jo');
      expect(sugestoes, containsAll(['João Silva', 'João Pedro']));
      expect(sugestoes.toSet().length, sugestoes.length);
      expect(sugestoes, isNot(contains('Maria Fernanda')));
    });

    test('busca livros por trecho do título', () async {
      await registrar(livroTitulo: 'Harry Potter e a Pedra Filosofal');
      await registrar(livroTitulo: 'Harry Potter e a Câmara Secreta');
      await registrar(livroTitulo: 'Dom Casmurro');

      final sugestoes = await repository.sugerirLivros('pedra');
      expect(sugestoes, ['Harry Potter E A Pedra Filosofal']);
    });

    test('não sugere nada para busca vazia', () async {
      await registrar();
      expect(await repository.sugerirAlunos(''), isEmpty);
    });
  });
}
