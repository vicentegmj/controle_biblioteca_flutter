import '../core/database/database.dart';

/// Visão completa de um item de empréstimo, com todos os dados relacionados
/// já resolvidos (aluno, turma, exemplar e livro) para exibição em telas de
/// consulta (em aberto, atrasados, histórico).
class EmprestimoItemDetalhado {
  EmprestimoItemDetalhado({
    required this.item,
    required this.emprestimo,
    required this.aluno,
    required this.turma,
    required this.exemplar,
    required this.livro,
  });

  final EmprestimoItem item;
  final Emprestimo emprestimo;
  final Aluno aluno;
  final Turma turma;
  final Exemplar exemplar;
  final Livro livro;

  bool get devolvido => item.dataDevolucao != null;

  bool get emAberto =>
      !devolvido && emprestimo.status == StatusEmprestimo.aberto;

  bool get atrasado =>
      emAberto && emprestimo.dataPrevistaDevolucao.isBefore(DateTime.now());

  int get diasAtraso {
    if (!atrasado) return 0;
    final hoje = DateTime.now();
    final prevista = emprestimo.dataPrevistaDevolucao;
    return DateTime(hoje.year, hoje.month, hoje.day)
        .difference(
          DateTime(prevista.year, prevista.month, prevista.day),
        )
        .inDays;
  }
}
