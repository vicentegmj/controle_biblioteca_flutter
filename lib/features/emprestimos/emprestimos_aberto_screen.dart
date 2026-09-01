import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
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
import 'emprestimos_providers.dart';

/// Consulta de todos os empréstimos atualmente em aberto (seção 12).
class EmprestimosAbertoScreen extends ConsumerStatefulWidget {
  const EmprestimosAbertoScreen({super.key});

  @override
  ConsumerState<EmprestimosAbertoScreen> createState() =>
      _EmprestimosAbertoScreenState();
}

class _EmprestimosAbertoScreenState extends ConsumerState<EmprestimosAbertoScreen> {
  final _buscaController = TextEditingController();

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

  Future<void> _cancelar(EmprestimoItemDetalhado item) async {
    final confirmado = await showConfirmDialog(
      context,
      titulo: 'Cancelar empréstimo',
      mensagem:
          'Cancelar o empréstimo de "${item.livro.titulo}" para ${item.aluno.nome}? '
          'O registro não será apagado, apenas marcado como cancelado. Só é '
          'possível cancelar empréstimos sem nenhum item já devolvido.',
      destrutivo: true,
      textoConfirmar: 'Cancelar empréstimo',
    );
    if (!confirmado) return;
    try {
      await ref.read(emprestimoServiceProvider).cancelarEmprestimo(item.emprestimo.id);
      if (mounted) showAppSnackBar(context, 'Empréstimo cancelado.');
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    }
  }

  void _abrirAluno(int alunoId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AlunoDetailScreen(alunoId: alunoId)),
    );
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
            hintText: 'Buscar por aluno, turma, livro ou código...',
            onChanged: (v) => ref
                .read(itensEmAbertoFiltroProvider.notifier)
                .update((s) => s.copyWith(busca: v)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itensAsync.when(
              data: (itens) {
                final filtrados = filtrarItens(itens, filtro.busca);
                if (filtrados.isEmpty) {
                  return const EmptyState(
                    mensagem: 'Nenhum empréstimo em aberto encontrado.',
                  );
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Livro')),
                        DataColumn(label: Text('Código')),
                        DataColumn(label: Text('Aluno')),
                        DataColumn(label: Text('Matrícula')),
                        DataColumn(label: Text('Turma')),
                        DataColumn(label: Text('Empréstimo')),
                        DataColumn(label: Text('Previsto')),
                        DataColumn(label: Text('Situação')),
                        DataColumn(label: Text('Ações')),
                      ],
                      rows: filtrados.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.livro.titulo)),
                            DataCell(Text(item.exemplar.codigo)),
                            DataCell(Text(item.aluno.nome)),
                            DataCell(Text(item.aluno.matricula ?? '-')),
                            DataCell(Text(item.turma.nome)),
                            DataCell(Text(formatDate(item.emprestimo.dataEmprestimo))),
                            DataCell(Text(formatDate(item.emprestimo.dataPrevistaDevolucao))),
                            DataCell(
                              item.atrasado
                                  ? StatusBadge(
                                      texto: 'Atrasado (${item.diasAtraso}d)',
                                      tone: BadgeTone.danger,
                                    )
                                  : const StatusBadge(
                                      texto: 'Em dia', tone: BadgeTone.info),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Ver aluno',
                                    icon: const Icon(Icons.person_outline),
                                    onPressed: () => _abrirAluno(item.aluno.id),
                                  ),
                                  IconButton(
                                    tooltip: 'Devolver',
                                    icon: const Icon(Icons.assignment_return_outlined),
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
