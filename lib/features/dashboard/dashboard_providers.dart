import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../models/emprestimo_extensions.dart';
import '../emprestimos/emprestimos_providers.dart';

class DashboardIndicadores {
  const DashboardIndicadores({
    required this.emAberto,
    required this.atrasados,
    required this.emprestimosHoje,
    required this.devolucoesHoje,
    required this.devolucoesAtrasadasOrdenadas,
  });

  final int emAberto;
  final int atrasados;
  final int emprestimosHoje;
  final int devolucoesHoje;
  final List<Emprestimo> devolucoesAtrasadasOrdenadas;
}

bool _mesmoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Usado só para contar empréstimos/devoluções feitos hoje — o stream de
/// itens "em aberto" não inclui um item já devolvido no mesmo dia.
final _todosItensProvider = StreamProvider<List<Emprestimo>>((ref) {
  return ref.watch(emprestimoRepositoryProvider).watchTodos();
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

  final atrasados = abertos.where((e) => e.atrasado).toList()
    ..sort((a, b) => a.dataPrevistaDevolucao.compareTo(b.dataPrevistaDevolucao));

  final emprestimosHoje = todos.where((e) => _mesmoDia(e.dataEmprestimo, hoje)).length;
  final devolucoesHoje = todos
      .where((e) => e.dataDevolucao != null && _mesmoDia(e.dataDevolucao!, hoje))
      .length;

  return AsyncValue.data(
    DashboardIndicadores(
      emAberto: abertos.length,
      atrasados: atrasados.length,
      emprestimosHoje: emprestimosHoje,
      devolucoesHoje: devolucoesHoje,
      devolucoesAtrasadasOrdenadas: atrasados,
    ),
  );
});
