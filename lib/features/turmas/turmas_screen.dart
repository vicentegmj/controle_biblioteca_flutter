import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import 'turma_form_dialog.dart';
import 'turmas_providers.dart';

class TurmasScreen extends ConsumerStatefulWidget {
  const TurmasScreen({super.key});

  @override
  ConsumerState<TurmasScreen> createState() => _TurmasScreenState();
}

class _TurmasScreenState extends ConsumerState<TurmasScreen> {
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _abrirFormulario([Turma? turma]) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => TurmaFormDialog(turma: turma),
    );
  }

  Future<void> _alternarAtiva(Turma turma) async {
    if (turma.ativo) {
      final confirmado = await showConfirmDialog(
        context,
        titulo: 'Inativar turma',
        mensagem:
            'Deseja inativar a turma "${turma.nome}"? Alunos vinculados '
            'permanecerão associados a ela, mas ela deixará de aparecer '
            'como opção para novos cadastros.',
      );
      if (!confirmado) return;
    }
    await ref.read(turmaRepositoryProvider).setAtiva(turma.id, !turma.ativo);
  }

  @override
  Widget build(BuildContext context) {
    final turmasAsync = ref.watch(turmasListProvider);
    final filtro = ref.watch(turmasFiltroProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            titulo: 'Turmas',
            subtitulo: 'Cadastro de turmas da escola',
            actions: [
              FilledButton.icon(
                onPressed: () => _abrirFormulario(),
                icon: const Icon(Icons.add),
                label: const Text('Nova Turma'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AppSearchField(
                controller: _buscaController,
                hintText: 'Buscar por nome ou série...',
                onChanged: (v) => ref
                    .read(turmasFiltroProvider.notifier)
                    .update((s) => s.copyWith(busca: v)),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('Somente ativas'),
                selected: filtro.apenasAtivas,
                onSelected: (v) => ref
                    .read(turmasFiltroProvider.notifier)
                    .update((s) => s.copyWith(apenasAtivas: v)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: turmasAsync.when(
              data: (turmas) {
                if (turmas.isEmpty) {
                  return const EmptyState(mensagem: 'Nenhuma turma encontrada.');
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nome')),
                        DataColumn(label: Text('Série')),
                        DataColumn(label: Text('Turno')),
                        DataColumn(label: Text('Ano letivo')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Ações')),
                      ],
                      rows: turmas
                          .map(
                            (t) => DataRow(
                              cells: [
                                DataCell(Text(t.nome)),
                                DataCell(Text(t.serie)),
                                DataCell(Text(t.turno)),
                                DataCell(Text(t.anoLetivo.toString())),
                                DataCell(
                                  StatusBadge(
                                    texto: t.ativo ? 'Ativa' : 'Inativa',
                                    tone: t.ativo
                                        ? BadgeTone.success
                                        : BadgeTone.neutral,
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Editar',
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () => _abrirFormulario(t),
                                      ),
                                      IconButton(
                                        tooltip: t.ativo ? 'Inativar' : 'Ativar',
                                        icon: Icon(
                                          t.ativo
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                        onPressed: () => _alternarAtiva(t),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
              error: (e, st) => EmptyState(
                icone: Icons.error_outline,
                mensagem: 'Erro ao carregar turmas: $e',
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
