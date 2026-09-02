import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/utils/turma_utils.dart';
import '../../models/emprestimo_extensions.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import '../emprestimos/emprestimos_providers.dart';
import 'historico_providers.dart';

enum _FiltroStatus { todos, aberto, devolvido, atrasado, cancelado }

/// Histórico geral de empréstimos, com busca livre e filtro estruturado de
/// turma (série/letra/ano letivo) — seção 12 do escopo.
class HistoricoScreen extends ConsumerStatefulWidget {
  const HistoricoScreen({super.key});

  @override
  ConsumerState<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends ConsumerState<HistoricoScreen> {
  final _buscaController = TextEditingController();
  final _serieController = TextEditingController();
  final _turmaController = TextEditingController();
  final _anoController = TextEditingController();
  _FiltroStatus _status = _FiltroStatus.todos;

  @override
  void dispose() {
    _buscaController.dispose();
    _serieController.dispose();
    _turmaController.dispose();
    _anoController.dispose();
    super.dispose();
  }

  bool _combinaComStatus(Emprestimo item) {
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
        return item.status == StatusEmprestimo.cancelado;
    }
  }

  bool _combinaComTurmaEstruturada(Emprestimo item) {
    final serie = int.tryParse(_serieController.text.trim());
    if (serie != null && item.serie != serie) return false;
    final letra = _turmaController.text.trim().toUpperCase();
    if (letra.isNotEmpty && item.turmaLetra != letra) return false;
    final ano = int.tryParse(_anoController.text.trim());
    if (ano != null && item.anoLetivo != ano) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final itensAsync = ref.watch(todosItensProvider);

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
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _serieController,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Série',
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _turmaController,
                  maxLength: 1,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Turma',
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(
                width: 110,
                child: TextField(
                  controller: _anoController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Ano letivo',
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<_FiltroStatus>(
                  initialValue: _status,
                  isDense: true,
                  decoration: const InputDecoration(labelText: 'Situação'),
                  items: const [
                    DropdownMenuItem(
                      value: _FiltroStatus.todos,
                      child: Text('Todos'),
                    ),
                    DropdownMenuItem(
                      value: _FiltroStatus.aberto,
                      child: Text('Em aberto'),
                    ),
                    DropdownMenuItem(
                      value: _FiltroStatus.devolvido,
                      child: Text('Devolvidos'),
                    ),
                    DropdownMenuItem(
                      value: _FiltroStatus.atrasado,
                      child: Text('Atrasados'),
                    ),
                    DropdownMenuItem(
                      value: _FiltroStatus.cancelado,
                      child: Text('Cancelados'),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _status = v ?? _FiltroStatus.todos),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: itensAsync.when(
              data: (itens) {
                var filtrados = filtrarEmprestimos(
                  itens,
                  _buscaController.text,
                );
                filtrados = filtrados
                    .where(_combinaComTurmaEstruturada)
                    .toList();
                filtrados = filtrados.where(_combinaComStatus).toList();

                if (filtrados.isEmpty) {
                  return const EmptyState(
                    mensagem: 'Nenhum registro encontrado.',
                  );
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: DataTable2(
                    fixedTopRows: 1,
                    minWidth: 950,
                    columns: const [
                      DataColumn2(label: Text('Aluno'), size: ColumnSize.L),
                      DataColumn2(label: Text('Turma')),
                      DataColumn2(label: Text('Livro'), size: ColumnSize.L),
                      DataColumn2(label: Text('Empréstimo')),
                      DataColumn2(label: Text('Previsto')),
                      DataColumn2(label: Text('Devolvido')),
                      DataColumn2(label: Text('Situação')),
                    ],
                    rows: filtrados.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.alunoNome)),
                          DataCell(
                            Text(
                              TurmaUtils.rotuloComAno(
                                item.serie,
                                item.turmaLetra,
                                item.anoLetivo,
                              ),
                            ),
                          ),
                          DataCell(Text(item.livroTitulo)),
                          DataCell(Text(formatDate(item.dataEmprestimo))),
                          DataCell(
                            Text(formatDate(item.dataPrevistaDevolucao)),
                          ),
                          DataCell(Text(formatDate(item.dataDevolucao))),
                          DataCell(_situacaoBadge(item)),
                        ],
                      );
                    }).toList(),
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

  Widget _situacaoBadge(Emprestimo item) {
    if (item.status == StatusEmprestimo.cancelado) {
      return const StatusBadge(texto: 'Cancelado', tone: BadgeTone.neutral);
    }
    if (item.devolvido) {
      return const StatusBadge(texto: 'Devolvido', tone: BadgeTone.success);
    }
    if (item.atrasado) {
      return StatusBadge(
        texto: 'Atrasado (${item.diasAtraso}d)',
        tone: BadgeTone.danger,
      );
    }
    return const StatusBadge(texto: 'Em aberto', tone: BadgeTone.info);
  }
}
