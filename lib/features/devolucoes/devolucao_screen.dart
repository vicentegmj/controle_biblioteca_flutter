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
import '../emprestimos/emprestimos_providers.dart';

/// Tela de devolução — pesquisa livre entre os empréstimos em aberto por
/// aluno, turma ou livro, e confirmação em um clique (seção 9 do escopo).
class DevolucaoScreen extends ConsumerStatefulWidget {
  const DevolucaoScreen({super.key});

  @override
  ConsumerState<DevolucaoScreen> createState() => _DevolucaoScreenState();
}

class _DevolucaoScreenState extends ConsumerState<DevolucaoScreen> {
  final _buscaController = TextEditingController();
  bool _confirmando = false;

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _confirmarDevolucao(Emprestimo item) async {
    final confirmado = await showConfirmDialog(
      context,
      titulo: 'Confirmar devolução',
      mensagem:
          'Confirmar a devolução de "${item.livroTitulo}" por ${item.alunoNome}?',
    );
    if (!confirmado) return;

    setState(() => _confirmando = true);
    try {
      await ref.read(emprestimoServiceProvider).devolver(item.id);
      if (mounted) {
        showAppSnackBar(
          context,
          'Devolução de "${item.livroTitulo}" registrada para ${item.alunoNome}.',
        );
      }
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    } finally {
      if (mounted) setState(() => _confirmando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itensAsync = ref.watch(itensAbertosProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Devolução',
            subtitulo: 'Pesquise por aluno, turma ou livro para localizar o empréstimo.',
          ),
          const SizedBox(height: 20),
          AppSearchField(
            controller: _buscaController,
            autofocus: true,
            hintText: 'Buscar por aluno, turma ou livro...',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itensAsync.when(
              data: (itens) {
                final filtrados = filtrarEmprestimos(
                  itens,
                  _buscaController.text,
                );
                if (filtrados.isEmpty) {
                  return EmptyState(
                    mensagem: _buscaController.text.trim().isEmpty
                        ? 'Nenhum empréstimo em aberto.'
                        : 'Nenhum empréstimo encontrado para essa busca.',
                  );
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: DataTable2(
                    fixedTopRows: 1,
                    minWidth: 1050,
                    columns: const [
                      DataColumn2(label: Text('Aluno'), size: ColumnSize.L),
                      DataColumn2(label: Text('Turma'), size: ColumnSize.S),
                      DataColumn2(label: Text('Livro'), size: ColumnSize.L),
                      DataColumn2(label: Text('Empréstimo')),
                      DataColumn2(label: Text('Previsto')),
                      DataColumn2(label: Text('Situação')),
                      DataColumn2(label: Text('Ações'), size: ColumnSize.L),
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
                                    texto: '${item.diasAtraso}d atraso',
                                    tone: BadgeTone.danger,
                                  )
                                : const StatusBadge(
                                    texto: 'Em dia',
                                    tone: BadgeTone.info,
                                  ),
                          ),
                          DataCell(
                            FilledButton.icon(
                              onPressed: _confirmando
                                  ? null
                                  : () => _confirmarDevolucao(item),
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('Confirmar Devolução'),
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
