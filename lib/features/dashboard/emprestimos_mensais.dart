import '../../core/database/database.dart';

class EmprestimosMes {
  const EmprestimosMes(this.mes, this.quantidade);

  final DateTime mes;
  final int quantidade;
}

List<EmprestimosMes> agruparEmprestimosPorMes(
  List<Emprestimo> itens, {
  required DateTime referencia,
  required int meses,
}) {
  assert(meses > 0);
  final inicio = DateTime(referencia.year, referencia.month - meses + 1);
  final contagens = List<int>.filled(meses, 0);
  for (final item in itens) {
    if (item.status == StatusEmprestimo.cancelado) continue;
    final data = item.dataEmprestimo;
    final indice = (data.year - inicio.year) * 12 + data.month - inicio.month;
    if (indice >= 0 && indice < meses) contagens[indice]++;
  }
  return List.generate(
    meses,
    (i) =>
        EmprestimosMes(DateTime(inicio.year, inicio.month + i), contagens[i]),
  );
}
