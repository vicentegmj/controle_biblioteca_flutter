import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../repositories/exemplar_repository.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import 'exemplar_form_dialog.dart';
import 'exemplar_historico_dialog.dart';
import 'livro_form_dialog.dart';
import 'livros_providers.dart';

class LivroDetailScreen extends ConsumerWidget {
  const LivroDetailScreen({super.key, required this.livro});

  final Livro livro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exemplaresAsync = ref.watch(exemplaresDoLivroProvider(livro.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(livro.titulo),
        actions: [
          IconButton(
            tooltip: 'Editar livro',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showDialog<bool>(
              context: context,
              builder: (_) => LivroFormDialog(livro: livro),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 32,
                  runSpacing: 12,
                  children: [
                    _infoTile('Autor', livro.autor),
                    _infoTile('Editora', livro.editora ?? '-'),
                    _infoTile('ISBN', livro.isbn ?? '-'),
                    _infoTile('Categoria', livro.categoria ?? '-'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            PageHeader(
              titulo: 'Exemplares',
              subtitulo: 'Exemplares físicos deste título',
              actions: [
                FilledButton.icon(
                  onPressed: () => showDialog<bool>(
                    context: context,
                    builder: (_) => ExemplarFormDialog(livroId: livro.id),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Novo Exemplar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: exemplaresAsync.when(
                data: (exemplares) {
                  if (exemplares.isEmpty) {
                    return const EmptyState(
                      mensagem: 'Nenhum exemplar cadastrado para este livro.',
                    );
                  }
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Código')),
                          DataColumn(label: Text('Código de barras')),
                          DataColumn(label: Text('Disponibilidade')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Ações')),
                        ],
                        rows: exemplares
                            .map((e) => _buildRow(context, ref, e))
                            .toList(),
                      ),
                    ),
                  );
                },
                error: (e, st) => EmptyState(
                  icone: Icons.error_outline,
                  mensagem: 'Erro ao carregar exemplares: $e',
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, ExemplarComLivro ec) {
    final exemplar = ec.exemplar;
    return DataRow(
      cells: [
        DataCell(Text(exemplar.codigo)),
        DataCell(Text(exemplar.codigoBarras ?? '-')),
        DataCell(
          StatusBadge(
            texto: ec.disponivel ? 'Disponível' : 'Emprestado',
            tone: ec.disponivel ? BadgeTone.success : BadgeTone.warning,
          ),
        ),
        DataCell(
          StatusBadge(
            texto: exemplar.ativo ? 'Ativo' : 'Inativo',
            tone: exemplar.ativo ? BadgeTone.success : BadgeTone.neutral,
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Histórico',
                icon: const Icon(Icons.history),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => ExemplarHistoricoDialog(
                    exemplarId: exemplar.id,
                    codigoExemplar: exemplar.codigo,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => showDialog<bool>(
                  context: context,
                  builder: (_) =>
                      ExemplarFormDialog(livroId: livro.id, exemplar: exemplar),
                ),
              ),
              IconButton(
                tooltip: exemplar.ativo ? 'Inativar' : 'Ativar',
                icon: Icon(
                  exemplar.ativo
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () async {
                  if (exemplar.ativo && !ec.disponivel) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Não é possível inativar um exemplar que está '
                          'emprestado no momento.',
                        ),
                      ),
                    );
                    return;
                  }
                  if (exemplar.ativo) {
                    final confirmado = await showConfirmDialog(
                      context,
                      titulo: 'Inativar exemplar',
                      mensagem:
                          'Deseja inativar o exemplar "${exemplar.codigo}"? '
                          'Ele deixará de poder ser emprestado.',
                    );
                    if (!confirmado) return;
                  }
                  await ref
                      .read(exemplarRepositoryProvider)
                      .setAtivo(exemplar.id, !exemplar.ativo);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTile(String label, String valor) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(valor, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
