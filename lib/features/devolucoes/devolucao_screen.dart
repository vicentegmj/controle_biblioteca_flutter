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
import '../emprestimos/emprestimos_providers.dart';

/// Tela de devolução — fluxo rápido por código de exemplar/código de barras,
/// com fallback para localizar na lista de empréstimos em aberto (seção 10).
class DevolucaoScreen extends ConsumerStatefulWidget {
  const DevolucaoScreen({super.key});

  @override
  ConsumerState<DevolucaoScreen> createState() => _DevolucaoScreenState();
}

class _DevolucaoScreenState extends ConsumerState<DevolucaoScreen> {
  final _codigoController = TextEditingController();
  final _codigoFocusNode = FocusNode();
  final _buscaListaController = TextEditingController();

  EmprestimoItemDetalhado? _itemLocalizado;
  String? _erroBusca;
  bool _confirmando = false;

  @override
  void dispose() {
    _codigoController.dispose();
    _codigoFocusNode.dispose();
    _buscaListaController.dispose();
    super.dispose();
  }

  Future<void> _localizarPorCodigo(String codigo) async {
    if (codigo.trim().isEmpty) return;
    setState(() {
      _erroBusca = null;
      _itemLocalizado = null;
    });
    final itens = await ref.read(emprestimoRepositoryProvider).getItensAbertos();
    final termo = codigo.trim().toLowerCase();
    final encontrados = itens.where(
      (i) =>
          i.exemplar.codigo.toLowerCase() == termo ||
          (i.exemplar.codigoBarras?.toLowerCase() ?? '') == termo,
    );
    if (encontrados.isEmpty) {
      setState(() => _erroBusca =
          'Nenhum empréstimo em aberto encontrado para o código "$codigo".');
      return;
    }
    setState(() => _itemLocalizado = encontrados.first);
  }

  Future<void> _confirmarDevolucao([EmprestimoItemDetalhado? item]) async {
    final alvo = item ?? _itemLocalizado;
    if (alvo == null) return;
    setState(() => _confirmando = true);
    try {
      await ref.read(emprestimoServiceProvider).devolverItem(alvo.item.id);
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Devolução de "${alvo.livro.titulo}" registrada para ${alvo.aluno.nome}.',
      );
      setState(() {
        _itemLocalizado = null;
        _codigoController.clear();
      });
      _codigoFocusNode.requestFocus();
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    } finally {
      if (mounted) setState(() => _confirmando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Devolução',
            subtitulo: 'Leia o código do exemplar ou localize na lista abaixo.',
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _codigoController,
                    focusNode: _codigoFocusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Código do exemplar ou código de barras',
                      hintText: 'Leia com o leitor ou digite e pressione Enter',
                      prefixIcon: Icon(Icons.qr_code_scanner),
                    ),
                    onSubmitted: _localizarPorCodigo,
                  ),
                  if (_erroBusca != null) ...[
                    const SizedBox(height: 12),
                    Text(_erroBusca!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  if (_itemLocalizado != null) ...[
                    const SizedBox(height: 16),
                    _buildItemLocalizado(_itemLocalizado!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Empréstimos em aberto', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          AppSearchField(
            controller: _buscaListaController,
            hintText: 'Buscar por aluno, matrícula ou livro...',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildListaAbertos()),
        ],
      ),
    );
  }

  Widget _buildItemLocalizado(EmprestimoItemDetalhado item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_book, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.livro.titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Exemplar ${item.exemplar.codigo}'),
                Text('${item.aluno.nome} · ${item.turma.nome}'),
                Text('Previsto: ${formatDate(item.emprestimo.dataPrevistaDevolucao)}'),
              ],
            ),
          ),
          if (item.atrasado) StatusBadge(texto: 'Atrasado (${item.diasAtraso}d)', tone: BadgeTone.danger),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: _confirmando ? null : () => _confirmarDevolucao(),
            icon: const Icon(Icons.check),
            label: const Text('Confirmar devolução'),
          ),
        ],
      ),
    );
  }

  Widget _buildListaAbertos() {
    final itensAsync = ref.watch(itensAbertosProvider);
    return itensAsync.when(
      data: (itens) {
        final filtrados = filtrarItens(itens, _buscaListaController.text);
        if (filtrados.isEmpty) {
          return const EmptyState(mensagem: 'Nenhum empréstimo em aberto.');
        }
        return Card(
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Aluno')),
                DataColumn(label: Text('Livro')),
                DataColumn(label: Text('Código')),
                DataColumn(label: Text('Previsto')),
                DataColumn(label: Text('Situação')),
                DataColumn(label: Text('Ações')),
              ],
              rows: filtrados.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.aluno.nome)),
                    DataCell(Text(item.livro.titulo)),
                    DataCell(Text(item.exemplar.codigo)),
                    DataCell(Text(formatDate(item.emprestimo.dataPrevistaDevolucao))),
                    DataCell(
                      item.atrasado
                          ? StatusBadge(texto: '${item.diasAtraso}d atraso', tone: BadgeTone.danger)
                          : const StatusBadge(texto: 'Em dia', tone: BadgeTone.info),
                    ),
                    DataCell(
                      IconButton(
                        tooltip: 'Devolver',
                        icon: const Icon(Icons.assignment_return_outlined),
                        onPressed: () async {
                          final confirmado = await showConfirmDialog(
                            context,
                            titulo: 'Confirmar devolução',
                            mensagem:
                                'Confirmar a devolução de "${item.livro.titulo}" por ${item.aluno.nome}?',
                          );
                          if (confirmado) await _confirmarDevolucao(item);
                        },
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
    );
  }
}
