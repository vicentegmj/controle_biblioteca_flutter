import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
import '../../models/emprestimo_item_detalhado.dart';
import '../emprestimos/emprestimos_providers.dart';

class DashboardIndicadores {
  const DashboardIndicadores({
    required this.emAberto,
    required this.atrasados,
    required this.emprestimosHoje,
    required this.devolucoesHoje,
    required this.alunosComLivros,
    required this.devolucoesAtrasadasOrdenadas,
  });

  final int emAberto;
  final int atrasados;
  final int emprestimosHoje;
  final int devolucoesHoje;
  final int alunosComLivros;
  final List<EmprestimoItemDetalhado> devolucoesAtrasadasOrdenadas;
}

bool _mesmoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Usado só para contar empréstimos/devoluções feitos hoje — o stream de
/// itens "em aberto" não inclui um item já devolvido no mesmo dia.
final _todosItensProvider = StreamProvider<List<EmprestimoItemDetalhado>>((ref) {
  return ref.watch(emprestimoRepositoryProvider).watchTodosItens();
});

final dashboardIndicadoresProvider = Provider<AsyncValue<DashboardIndicadores>>((ref) {
  final itensAsync = ref.watch(itensAbertosProvider);
  final historicoAsync = ref.watch(_todosItensProvider);

  if (itensAsync.isLoading || historicoAsync.isLoading) {
    return const AsyncValue.loading();
  }
  final erro = itensAsync.hasError ? itensAsync.error : historicoAsync.error;
  if (erro != null) {
    return AsyncValue.error(erro, StackTrace.current);
  }

  final abertos = itensAsync.value ?? [];
  final todos = historicoAsync.value ?? [];
  final hoje = DateTime.now();

  final atrasados = abertos.where((i) => i.atrasado).toList()
    ..sort((a, b) =>
        a.emprestimo.dataPrevistaDevolucao.compareTo(b.emprestimo.dataPrevistaDevolucao));

  final emprestimosHoje = todos
      .where((i) => _mesmoDia(i.emprestimo.dataEmprestimo, hoje))
      .map((i) => i.emprestimo.id)
      .toSet()
      .length;
  final devolucoesHoje = todos
      .where((i) => i.item.dataDevolucao != null && _mesmoDia(i.item.dataDevolucao!, hoje))
      .length;
  final alunosComLivros = abertos.map((i) => i.aluno.id).toSet().length;

  return AsyncValue.data(
    DashboardIndicadores(
      emAberto: abertos.length,
      atrasados: atrasados.length,
      emprestimosHoje: emprestimosHoje,
      devolucoesHoje: devolucoesHoje,
      alunosComLivros: alunosComLivros,
      devolucoesAtrasadasOrdenadas: atrasados,
    ),
  );
});
