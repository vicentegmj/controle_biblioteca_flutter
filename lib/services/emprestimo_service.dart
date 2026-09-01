// ignore_for_file: prefer_initializing_formals
import 'package:drift/drift.dart' show Value;

import '../core/database/database.dart';
import '../core/utils/domain_exception.dart';
import '../core/utils/turma_utils.dart';
import '../repositories/configuracao_repository.dart';
import '../repositories/emprestimo_repository.dart';

/// Orquestra as regras de negócio de empréstimo/devolução/cancelamento.
///
/// Toda validação de domínio vive aqui, não na interface — os widgets
/// apenas chamam estes métodos e exibem a [DomainException] resultante.
class EmprestimoService {
  EmprestimoService({
    required EmprestimoRepository emprestimoRepository,
    required ConfiguracaoRepository configuracaoRepository,
  })  : _emprestimoRepository = emprestimoRepository,
        _configuracaoRepository = configuracaoRepository;

  final EmprestimoRepository _emprestimoRepository;
  final ConfiguracaoRepository _configuracaoRepository;

  static final RegExp _letraTurmaValida = RegExp(r'^[A-Z]$');

  /// Calcula a data prevista de devolução a partir do prazo padrão
  /// configurado.
  Future<DateTime> calcularDataPrevista(DateTime dataEmprestimo) async {
    final prazo = await _configuracaoRepository.getPrazoPadraoDias();
    return DateTime(
      dataEmprestimo.year,
      dataEmprestimo.month,
      dataEmprestimo.day + prazo,
      dataEmprestimo.hour,
      dataEmprestimo.minute,
    );
  }

  /// Registra um novo empréstimo, validando os campos obrigatórios.
  ///
  /// O ano letivo nunca é recebido do chamador: é sempre derivado do ano de
  /// [dataEmprestimo].
  Future<int> registrarEmprestimo({
    required String alunoNome,
    required int serie,
    required String turmaLetra,
    required String livroTitulo,
    required DateTime dataEmprestimo,
    required DateTime dataPrevistaDevolucao,
    String? observacao,
  }) async {
    final aluno = alunoNome.trim();
    final livro = livroTitulo.trim();
    final letra = turmaLetra.trim().toUpperCase();

    if (aluno.isEmpty) {
      throw const DomainException('Informe o nome do aluno.');
    }
    if (livro.isEmpty) {
      throw const DomainException('Informe o título do livro.');
    }
    if (serie < 1 || serie > 9) {
      throw const DomainException('Informe uma série válida (1 a 9).');
    }
    if (!_letraTurmaValida.hasMatch(letra)) {
      throw const DomainException('Informe a letra da turma (ex.: A, B, C).');
    }
    if (dataPrevistaDevolucao.isBefore(dataEmprestimo)) {
      throw const DomainException(
        'A data prevista de devolução não pode ser anterior à data do empréstimo.',
      );
    }

    return _emprestimoRepository.criarEmprestimo(
      EmprestimosCompanion.insert(
        alunoNome: aluno,
        serie: serie,
        turmaLetra: letra,
        anoLetivo: TurmaUtils.anoLetivoDe(dataEmprestimo),
        livroTitulo: livro,
        dataEmprestimo: dataEmprestimo,
        dataPrevistaDevolucao: dataPrevistaDevolucao,
        observacao: Value(observacao?.trim().isEmpty == true ? null : observacao?.trim()),
      ),
    );
  }

  /// Confirma a devolução de um empréstimo em aberto.
  Future<void> devolver(int id) async {
    final emprestimo = await _emprestimoRepository.getById(id);
    if (emprestimo == null) {
      throw const DomainException('Empréstimo não encontrado.');
    }
    if (emprestimo.status != StatusEmprestimo.aberto) {
      throw const DomainException('Este empréstimo não está em aberto.');
    }
    await _emprestimoRepository.devolver(id);
  }

  /// Cancela um empréstimo lançado incorretamente. Só é permitido enquanto
  /// ele ainda estiver em aberto (não faz sentido cancelar algo já
  /// devolvido).
  Future<void> cancelar(int id) async {
    final emprestimo = await _emprestimoRepository.getById(id);
    if (emprestimo == null) {
      throw const DomainException('Empréstimo não encontrado.');
    }
    if (emprestimo.status != StatusEmprestimo.aberto) {
      throw const DomainException(
        'Somente empréstimos em aberto podem ser cancelados.',
      );
    }
    await _emprestimoRepository.cancelar(id);
  }
}
