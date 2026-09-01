// ignore_for_file: prefer_initializing_formals
import '../core/database/database.dart';
import '../core/utils/domain_exception.dart';
import '../repositories/aluno_repository.dart';
import '../repositories/configuracao_repository.dart';
import '../repositories/emprestimo_repository.dart';
import '../repositories/exemplar_repository.dart';

/// Orquestra as regras de negócio de empréstimo/devolução/cancelamento.
///
/// Toda validação de domínio vive aqui, não na interface — os widgets
/// apenas chamam estes métodos e exibem a [DomainException] resultante.
class EmprestimoService {
  EmprestimoService({
    required EmprestimoRepository emprestimoRepository,
    required AlunoRepository alunoRepository,
    required ExemplarRepository exemplarRepository,
    required ConfiguracaoRepository configuracaoRepository,
  })  : _emprestimoRepository = emprestimoRepository,
        _alunoRepository = alunoRepository,
        _exemplarRepository = exemplarRepository,
        _configuracaoRepository = configuracaoRepository;

  final EmprestimoRepository _emprestimoRepository;
  final AlunoRepository _alunoRepository;
  final ExemplarRepository _exemplarRepository;
  final ConfiguracaoRepository _configuracaoRepository;

  /// Calcula a data prevista de devolução a partir do prazo padrão
  /// configurado (seção 9 do escopo).
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

  /// Registra um novo empréstimo com um ou mais exemplares, validando todas
  /// as regras de domínio antes de gravar.
  Future<int> registrarEmprestimo({
    required int alunoId,
    required DateTime dataEmprestimo,
    required DateTime dataPrevistaDevolucao,
    required List<int> exemplarIds,
    String? observacoes,
  }) async {
    if (exemplarIds.isEmpty) {
      throw const DomainException(
        'Selecione ao menos um exemplar para o empréstimo.',
      );
    }
    if (exemplarIds.toSet().length != exemplarIds.length) {
      throw const DomainException(
        'Não é possível emprestar o mesmo exemplar duas vezes no mesmo empréstimo.',
      );
    }

    final aluno = await _alunoRepository.getById(alunoId);
    if (aluno == null) {
      throw const DomainException('Aluno não encontrado.');
    }
    if (!aluno.ativo) {
      throw DomainException(
        'O aluno ${aluno.nome} está inativo e não pode realizar novos empréstimos.',
      );
    }

    final bloquearSeAtraso =
        await _configuracaoRepository.getBloquearEmprestimoSeAtraso();
    if (bloquearSeAtraso) {
      final possuiAtraso = await _emprestimoRepository.alunoPossuiAtraso(alunoId);
      if (possuiAtraso) {
        throw DomainException(
          'O aluno ${aluno.nome} possui empréstimo(s) em atraso e não pode '
          'realizar novos empréstimos até regularizar a situação.',
        );
      }
    }

    final maxSimultaneos =
        await _configuracaoRepository.getMaxEmprestimosSimultaneos();
    final abertosAtuais =
        await _emprestimoRepository.countItensAbertosDoAluno(alunoId);
    if (abertosAtuais + exemplarIds.length > maxSimultaneos) {
      throw DomainException(
        'O aluno ${aluno.nome} já possui $abertosAtuais empréstimo(s) em '
        'aberto. O limite simultâneo configurado é $maxSimultaneos.',
      );
    }

    for (final exemplarId in exemplarIds) {
      final exemplar = await _exemplarRepository.getById(exemplarId);
      if (exemplar == null) {
        throw const DomainException('Exemplar não encontrado.');
      }
      if (!exemplar.ativo) {
        throw DomainException(
          'O exemplar ${exemplar.codigo} está inativo e não pode ser emprestado.',
        );
      }
      final jaEmprestado =
          await _emprestimoRepository.exemplarEstaEmprestado(exemplarId);
      if (jaEmprestado) {
        throw DomainException(
          'O exemplar ${exemplar.codigo} já está emprestado.',
        );
      }
    }

    return _emprestimoRepository.criarEmprestimo(
      alunoId: alunoId,
      dataEmprestimo: dataEmprestimo,
      dataPrevistaDevolucao: dataPrevistaDevolucao,
      exemplarIds: exemplarIds,
      observacoes: observacoes,
    );
  }

  /// Confirma a devolução de um item de empréstimo específico.
  Future<void> devolverItem(int itemId) async {
    await _emprestimoRepository.devolverItem(itemId);
  }

  /// Cancela um empréstimo lançado incorretamente. Só é permitido quando
  /// nenhum item do empréstimo já tiver sido devolvido (regra 22).
  Future<void> cancelarEmprestimo(int emprestimoId) async {
    final emprestimo = await _emprestimoRepository.getEmprestimoById(
      emprestimoId,
    );
    if (emprestimo == null) {
      throw const DomainException('Empréstimo não encontrado.');
    }
    if (emprestimo.status != StatusEmprestimo.aberto) {
      throw const DomainException(
        'Somente empréstimos em aberto podem ser cancelados.',
      );
    }
    final itens = await _emprestimoRepository.getItensDoEmprestimo(
      emprestimoId,
    );
    final algumDevolvido = itens.any((i) => i.dataDevolucao != null);
    if (algumDevolvido) {
      throw const DomainException(
        'Este empréstimo já possui item(ns) devolvido(s) e não pode mais '
        'ser cancelado.',
      );
    }
    await _emprestimoRepository.cancelarEmprestimo(emprestimoId);
  }
}
