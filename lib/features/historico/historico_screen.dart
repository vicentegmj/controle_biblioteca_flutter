import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/utils/date_formatters.dart';
import '../../models/emprestimo_item_detalhado.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import '../alunos/aluno_detail_screen.dart';
import '../emprestimos/emprestimos_providers.dart';
import '../turmas/turmas_providers.dart';
import 'historico_providers.dart';

enum _FiltroStatus { todos, aberto, devolvido, atrasado, cancelado }

/// Histórico geral de empréstimos, com filtros por aluno/turma/livro e
/// situação (seção 4, módulo Histórico).
class HistoricoScreen extends ConsumerStatefulWidget {
  const HistoricoScreen({super.key});

  @override
  ConsumerState<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends ConsumerState<HistoricoScreen> {
  final _buscaController = TextEditingController();
  int? _turmaId;
  _FiltroStatus _status = _FiltroStatus.todos;

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  bool _combinaComStatus(EmprestimoItemDetalhado item) {
    switch (_status) {
      case _FiltroStatus.todos:
        return true;
      case _FiltroStatus.aberto:
        return item.emAberto && !item.atrasado;
      case _FiltroStatus.devolvido:
        return item.devolvido;
      case _FiltroStatus.atrasado:
        return item.atrasado;
      case _FiltroStatus.cancelado:
        return item.emprestimo.status == StatusEmprestimo.cancelado;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itensAsync = ref.watch(todosItensProvider);
    final turmasAsync = ref.watch(turmasListProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Histórico',
            subtitulo: 'Todos os empréstimos já registrados no sistema',
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
                onChanged: (_) => setState(() {}),
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
                width: 200,
                child: DropdownButtonFormField<_FiltroStatus>(
                  initialValue: _status,
                  isDense: true,
                  decoration: const InputDecoration(labelText: 'Situação'),
                  items: const [
                    DropdownMenuItem(value: _FiltroStatus.todos, child: Text('Todos')),
                    DropdownMenuItem(value: _FiltroStatus.aberto, child: Text('Em aberto')),
                    DropdownMenuItem(value: _FiltroStatus.devolvido, child: Text('Devolvidos')),
                    DropdownMenuItem(value: _FiltroStatus.atrasado, child: Text('Atrasados')),
                    DropdownMenuItem(value: _FiltroStatus.cancelado, child: Text('Cancelados')),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? _FiltroStatus.todos),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itensAsync.when(
              data: (itens) {
                var filtrados = filtrarItens(itens, _buscaController.text);
                if (_turmaId != null) {
                  filtrados = filtrados.where((i) => i.turma.id == _turmaId).toList();
                }
                filtrados = filtrados.where(_combinaComStatus).toList();

                if (filtrados.isEmpty) {
                  return const EmptyState(mensagem: 'Nenhum registro encontrado.');
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Aluno')),
                        DataColumn(label: Text('Turma')),
                        DataColumn(label: Text('Livro')),
                        DataColumn(label: Text('Código')),
                        DataColumn(label: Text('Empréstimo')),
                        DataColumn(label: Text('Previsto')),
                        DataColumn(label: Text('Devolvido')),
                        DataColumn(label: Text('Situação')),
                      ],
                      rows: filtrados.map((item) {
                        return DataRow(
                          onSelectChanged: (_) => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AlunoDetailScreen(alunoId: item.aluno.id),
                            ),
                          ),
                          cells: [
                            DataCell(Text(item.aluno.nome)),
                            DataCell(Text(item.turma.nome)),
                            DataCell(Text(item.livro.titulo)),
                            DataCell(Text(item.exemplar.codigo)),
                            DataCell(Text(formatDate(item.emprestimo.dataEmprestimo))),
                            DataCell(Text(formatDate(item.emprestimo.dataPrevistaDevolucao))),
                            DataCell(Text(formatDate(item.item.dataDevolucao))),
                            DataCell(_situacaoBadge(item)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              error: (e, st) => EmptyState(
                icone: Icons.error_outline,
                mensagem: 'Erro ao carregar histórico: $e',
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _situacaoBadge(EmprestimoItemDetalhado item) {
    if (item.emprestimo.status == StatusEmprestimo.cancelado) {
      return const StatusBadge(texto: 'Cancelado', tone: BadgeTone.neutral);
    }
    if (item.devolvido) {
      return const StatusBadge(texto: 'Devolvido', tone: BadgeTone.success);
    }
    if (item.atrasado) {
      return StatusBadge(texto: 'Atrasado (${item.diasAtraso}d)', tone: BadgeTone.danger);
    }
    return const StatusBadge(texto: 'Em aberto', tone: BadgeTone.info);
  }
}
