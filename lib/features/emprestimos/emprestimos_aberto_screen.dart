import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/utils/domain_exception.dart';
import '../../core/utils/turma_utils.dart';
import '../../models/emprestimo_extensions.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import 'emprestimos_providers.dart';

/// Consulta de todos os empréstimos atualmente em aberto (seção 10).
class EmprestimosAbertoScreen extends ConsumerStatefulWidget {
  const EmprestimosAbertoScreen({super.key});

  @override
  ConsumerState<EmprestimosAbertoScreen> createState() =>
      _EmprestimosAbertoScreenState();
}

class _EmprestimosAbertoScreenState
    extends ConsumerState<EmprestimosAbertoScreen> {
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _devolver(Emprestimo item) async {
    final confirmado = await showConfirmDialog(
      context,
      titulo: 'Confirmar devolução',
      mensagem:
          'Confirmar a devolução de "${item.livroTitulo}" por ${item.alunoNome}?',
    );
    if (!confirmado) return;
    try {
      await ref.read(emprestimoServiceProvider).devolver(item.id);
      if (mounted) showAppSnackBar(context, 'Devolução registrada.');
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    }
  }

  Future<void> _cancelar(Emprestimo item) async {
    final confirmado = await showConfirmDialog(
      context,
      titulo: 'Cancelar empréstimo',
      mensagem:
          'Cancelar o empréstimo de "${item.livroTitulo}" para ${item.alunoNome}? '
          'O registro não será apagado, apenas marcado como cancelado.',
      destrutivo: true,
      textoConfirmar: 'Cancelar empréstimo',
    );
    if (!confirmado) return;
    try {
      await ref.read(emprestimoServiceProvider).cancelar(item.id);
      if (mounted) showAppSnackBar(context, 'Empréstimo cancelado.');
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itensAsync = ref.watch(itensAbertosProvider);
    final filtro = ref.watch(itensEmAbertoFiltroProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Empréstimos em Aberto',
            subtitulo: 'Todos os livros atualmente emprestados',
          ),
          const SizedBox(height: 16),
          AppSearchField(
            controller: _buscaController,
            hintText: 'Buscar por aluno, turma ou livro...',
            onChanged: (v) => ref
                .read(itensEmAbertoFiltroProvider.notifier)
                .update((s) => s.copyWith(busca: v)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itensAsync.when(
              data: (itens) {
                final filtrados = filtrarEmprestimos(itens, filtro.busca);
                if (filtrados.isEmpty) {
                  return const EmptyState(
                    mensagem: 'Nenhum empréstimo em aberto encontrado.',
                  );
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: DataTable2(
                    fixedTopRows: 1,
                    minWidth: 900,
                    columns: const [
                      DataColumn2(label: Text('Aluno'), size: ColumnSize.L),
                      DataColumn2(label: Text('Turma'), size: ColumnSize.S),
                      DataColumn2(label: Text('Livro'), size: ColumnSize.L),
                      DataColumn2(label: Text('Empréstimo')),
                      DataColumn2(label: Text('Previsto')),
                      DataColumn2(label: Text('Situação')),
                      DataColumn2(label: Text('Ações'), size: ColumnSize.S),
                    ],
                    rows: filtrados.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.alunoNome)),
                          DataCell(
                            Text(
                              TurmaUtils.rotulo(item.serie, item.turmaLetra),
                            ),
                          ),
                          DataCell(Text(item.livroTitulo)),
                          DataCell(Text(formatDate(item.dataEmprestimo))),
                          DataCell(
                            Text(formatDate(item.dataPrevistaDevolucao)),
                          ),
                          DataCell(
                            item.atrasado
                                ? StatusBadge(
                                    texto: 'Atrasado (${item.diasAtraso}d)',
                                    tone: BadgeTone.danger,
                                  )
                                : const StatusBadge(
                                    texto: 'Em dia',
                                    tone: BadgeTone.info,
                                  ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Devolver',
                                  icon: const Icon(
                                    Icons.assignment_return_outlined,
                                  ),
                                  onPressed: () => _devolver(item),
                                ),
                                IconButton(
                                  tooltip: 'Cancelar empréstimo',
                                  icon: const Icon(Icons.cancel_outlined),
                                  onPressed: () => _cancelar(item),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
              error: (e, st) => EmptyState(
                icone: Icons.error_outline,
                mensagem: 'Erro ao carregar empréstimos: $e',
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
