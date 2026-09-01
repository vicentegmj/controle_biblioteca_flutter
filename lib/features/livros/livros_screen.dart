import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import 'livro_detail_screen.dart';
import 'livro_form_dialog.dart';
import 'livros_providers.dart';

class LivrosScreen extends ConsumerStatefulWidget {
  const LivrosScreen({super.key});

  @override
  ConsumerState<LivrosScreen> createState() => _LivrosScreenState();
}

class _LivrosScreenState extends ConsumerState<LivrosScreen> {
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _abrirFormulario([Livro? livro]) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => LivroFormDialog(livro: livro),
    );
  }

  void _abrirDetalhe(Livro livro) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LivroDetailScreen(livro: livro)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final livrosAsync = ref.watch(livrosListProvider);
    final filtro = ref.watch(livrosFiltroProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            titulo: 'Livros',
            subtitulo: 'Cadastro bibliográfico usado para identificar empréstimos',
            actions: [
              FilledButton.icon(
                onPressed: () => _abrirFormulario(),
                icon: const Icon(Icons.add),
                label: const Text('Novo Livro'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppSearchField(
                controller: _buscaController,
                hintText: 'Buscar por título ou autor...',
                onChanged: (v) => ref
                    .read(livrosFiltroProvider.notifier)
                    .update((s) => s.copyWith(busca: v)),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<bool?>(
                  initialValue: filtro.ativo,
                  isDense: true,
                  decoration: const InputDecoration(labelText: 'Situação'),
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Ativos')),
                    DropdownMenuItem(value: false, child: Text('Inativos')),
                    DropdownMenuItem(value: null, child: Text('Todos')),
                  ],
                  onChanged: (v) => ref
                      .read(livrosFiltroProvider.notifier)
                      .update((s) => s.copyWith(ativo: () => v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: livrosAsync.when(
              data: (livros) {
                if (livros.isEmpty) {
                  return const EmptyState(mensagem: 'Nenhum livro encontrado.');
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Título')),
                        DataColumn(label: Text('Autor')),
                        DataColumn(label: Text('Categoria')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Ações')),
                      ],
                      rows: livros
                          .map(
                            (l) => DataRow(
                              onSelectChanged: (_) => _abrirDetalhe(l),
                              cells: [
                                DataCell(Text(l.titulo)),
                                DataCell(Text(l.autor)),
                                DataCell(Text(l.categoria ?? '-')),
                                DataCell(
                                  StatusBadge(
                                    texto: l.ativo ? 'Ativo' : 'Inativo',
                                    tone: l.ativo
                                        ? BadgeTone.success
                                        : BadgeTone.neutral,
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Exemplares',
                                        icon: const Icon(Icons.style_outlined),
                                        onPressed: () => _abrirDetalhe(l),
                                      ),
                                      IconButton(
                                        tooltip: 'Editar',
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () => _abrirFormulario(l),
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
                mensagem: 'Erro ao carregar livros: $e',
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
