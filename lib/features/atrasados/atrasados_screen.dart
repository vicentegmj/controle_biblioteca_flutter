import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_formatters.dart';
import '../../core/utils/domain_exception.dart';
import '../../models/emprestimo_item_detalhado.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import '../alunos/aluno_detail_screen.dart';
import '../emprestimos/emprestimos_providers.dart';
import '../turmas/turmas_providers.dart';
import '../../core/database/repository_providers.dart';

/// Tela de empréstimos atrasados (seção 11).
///
/// O atraso não é armazenado no banco — é calculado a partir da data
/// prevista de devolução dos itens ainda em aberto.
class AtrasadosScreen extends ConsumerStatefulWidget {
  const AtrasadosScreen({super.key});

  @override
  ConsumerState<AtrasadosScreen> createState() => _AtrasadosScreenState();
}

class _AtrasadosScreenState extends ConsumerState<AtrasadosScreen> {
  final _buscaController = TextEditingController();
  int? _turmaId;
  int _minDiasAtraso = 0;

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _devolver(EmprestimoItemDetalhado item) async {
    final confirmado = await showConfirmDialog(
      context,
      titulo: 'Confirmar devolução',
      mensagem:
          'Confirmar a devolução de "${item.livro.titulo}" (${item.exemplar.codigo}) '
          'por ${item.aluno.nome}?',
    );
    if (!confirmado) return;
    try {
      await ref.read(emprestimoServiceProvider).devolverItem(item.item.id);
      if (mounted) showAppSnackBar(context, 'Devolução registrada.');
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itensAsync = ref.watch(itensAbertosProvider);
    final turmasAsync = ref.watch(turmasListProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Empréstimos Atrasados',
            subtitulo: 'Itens em aberto cuja data prevista já passou',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppSearchField(
                controller: _buscaController,
                hintText: 'Buscar por aluno, turma ou livro...',
                onChanged: (v) => setState(() {}),
              ),
              turmasAsync.maybeWhen(
                data: (turmas) => SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<int?>(
                    initialValue: _turmaId,
                    isDense: true,
                    decoration: const InputDecoration(labelText: 'Turma'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas')),
                      ...turmas.map(
                        (t) => DropdownMenuItem(value: t.id, child: Text(t.nome)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _turmaId = v),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<int>(
                  initialValue: _minDiasAtraso,
                  isDense: true,
                  decoration: const InputDecoration(labelText: 'Mínimo de dias em atraso'),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Qualquer atraso')),
                    DropdownMenuItem(value: 3, child: Text('3 dias ou mais')),
                    DropdownMenuItem(value: 7, child: Text('7 dias ou mais')),
                    DropdownMenuItem(value: 15, child: Text('15 dias ou mais')),
                    DropdownMenuItem(value: 30, child: Text('30 dias ou mais')),
                  ],
                  onChanged: (v) => setState(() => _minDiasAtraso = v ?? 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itensAsync.when(
              data: (itens) {
                var atrasados = itens.where((i) => i.atrasado).toList();
                if (_turmaId != null) {
                  atrasados = atrasados.where((i) => i.turma.id == _turmaId).toList();
                }
                if (_minDiasAtraso > 0) {
                  atrasados =
                      atrasados.where((i) => i.diasAtraso >= _minDiasAtraso).toList();
                }
                atrasados = filtrarItens(atrasados, _buscaController.text);
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
                        DataColumn(label: Text('Matrícula')),
                        DataColumn(label: Text('Turma')),
                        DataColumn(label: Text('Livro')),
                        DataColumn(label: Text('Código')),
                        DataColumn(label: Text('Empréstimo')),
                        DataColumn(label: Text('Previsto')),
                        DataColumn(label: Text('Dias em atraso')),
                        DataColumn(label: Text('Ações')),
                      ],
                      rows: atrasados.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.aluno.nome)),
                            DataCell(Text(item.aluno.matricula ?? '-')),
                            DataCell(Text(item.turma.nome)),
                            DataCell(Text(item.livro.titulo)),
                            DataCell(Text(item.exemplar.codigo)),
                            DataCell(Text(formatDate(item.emprestimo.dataEmprestimo))),
                            DataCell(Text(formatDate(item.emprestimo.dataPrevistaDevolucao))),
                            DataCell(
                              StatusBadge(
                                texto: '${item.diasAtraso} dia(s)',
                                tone: BadgeTone.danger,
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Ver aluno',
                                    icon: const Icon(Icons.person_outline),
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AlunoDetailScreen(alunoId: item.aluno.id),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Devolver',
                                    icon: const Icon(Icons.assignment_return_outlined),
                                    onPressed: () => _devolver(item),
                                  ),
                                ],
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
