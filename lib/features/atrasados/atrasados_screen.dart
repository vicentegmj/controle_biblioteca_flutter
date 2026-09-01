import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
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
import '../../core/database/repository_providers.dart';
import '../emprestimos/emprestimos_providers.dart';

/// Tela de empréstimos atrasados (seção 11).
///
/// O atraso não é armazenado no banco — é calculado a partir da data
/// prevista de devolução dos empréstimos ainda em aberto.
class AtrasadosScreen extends ConsumerStatefulWidget {
  const AtrasadosScreen({super.key});

  @override
  ConsumerState<AtrasadosScreen> createState() => _AtrasadosScreenState();
}

class _AtrasadosScreenState extends ConsumerState<AtrasadosScreen> {
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
      mensagem: 'Confirmar a devolução de "${item.livroTitulo}" por ${item.alunoNome}?',
    );
    if (!confirmado) return;
    try {
      await ref.read(emprestimoServiceProvider).devolver(item.id);
      if (mounted) showAppSnackBar(context, 'Devolução registrada.');
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
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
            titulo: 'Empréstimos Atrasados',
            subtitulo: 'Empréstimos em aberto cuja data prevista já passou',
          ),
          const SizedBox(height: 16),
          AppSearchField(
            controller: _buscaController,
            hintText: 'Buscar por aluno, turma ou livro...',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itensAsync.when(
              data: (itens) {
                var atrasados = itens.where((e) => e.atrasado).toList();
                atrasados = filtrarEmprestimos(atrasados, _buscaController.text);
                atrasados.sort((a, b) => b.diasAtraso.compareTo(a.diasAtraso));

                if (atrasados.isEmpty) {
                  return const EmptyState(
                    mensagem: 'Nenhum empréstimo atrasado encontrado. 🎉',
                    icone: Icons.check_circle_outline,
                  );
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Aluno')),
                        DataColumn(label: Text('Turma')),
                        DataColumn(label: Text('Livro')),
                        DataColumn(label: Text('Empréstimo')),
                        DataColumn(label: Text('Previsto')),
                        DataColumn(label: Text('Dias em atraso')),
                        DataColumn(label: Text('Ações')),
                      ],
                      rows: atrasados.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.alunoNome)),
                            DataCell(Text(TurmaUtils.rotulo(item.serie, item.turmaLetra))),
                            DataCell(Text(item.livroTitulo)),
                            DataCell(Text(formatDate(item.dataEmprestimo))),
                            DataCell(Text(formatDate(item.dataPrevistaDevolucao))),
                            DataCell(
                              StatusBadge(
                                texto: '${item.diasAtraso} dia(s)',
                                tone: BadgeTone.danger,
                              ),
                            ),
                            DataCell(
                              IconButton(
                                tooltip: 'Devolver',
                                icon: const Icon(Icons.assignment_return_outlined),
                                onPressed: () => _devolver(item),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              error: (e, st) => EmptyState(
                icone: Icons.error_outline,
                mensagem: 'Erro ao carregar atrasados: $e',
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
