import '../core/database/database.dart';

/// Propriedades calculadas de um empréstimo (nunca persistidas).
extension EmprestimoStatusX on Emprestimo {
  bool get devolvido => dataDevolucao != null;

  bool get emAberto => status == StatusEmprestimo.aberto && !devolvido;

  bool get atrasado =>
      emAberto && dataPrevistaDevolucao.isBefore(DateTime.now());

  int get diasAtraso {
    if (!atrasado) return 0;
    final hoje = DateTime.now();
    return DateTime(hoje.year, hoje.month, hoje.day)
        .difference(DateTime(
          dataPrevistaDevolucao.year,
          dataPrevistaDevolucao.month,
          dataPrevistaDevolucao.day,
        ))
        .inDays;
  }
}
