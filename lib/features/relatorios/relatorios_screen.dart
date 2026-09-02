import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/utils/config_keys.dart';
import '../../services/relatorio_emprestimos_pdf_service.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../configuracoes/configuracoes_providers.dart';
import '../emprestimos/emprestimos_providers.dart';

class RelatoriosScreen extends ConsumerStatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  ConsumerState<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends ConsumerState<RelatoriosScreen> {
  static const _service = RelatorioEmprestimosPdfService();

  TipoRelatorioEmprestimos _tipo = TipoRelatorioEmprestimos.emAberto;
  OrdenacaoRelatorioEmprestimos _ordenacao =
      OrdenacaoRelatorioEmprestimos.dataEmprestimo;
  bool _gerando = false;

  @override
  Widget build(BuildContext context) {
    final emprestimosAsync = ref.watch(itensAbertosProvider);
    final configuracoes = ref.watch(configuracaoStreamProvider).value;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Relatórios',
            subtitulo: 'Gere relatórios de empréstimos em formato PDF',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: emprestimosAsync.when(
              data: (emprestimos) {
                final selecionados = _service.prepararDados(
                  emprestimos: emprestimos,
                  tipo: _tipo,
                  ordenacao: _ordenacao,
                );
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipo de relatório',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            SegmentedButton<TipoRelatorioEmprestimos>(
                              segments: const [
                                ButtonSegment(
                                  value: TipoRelatorioEmprestimos.emAberto,
                                  label: Text('Em aberto'),
                                  icon: Icon(Icons.folder_open_outlined),
                                ),
                                ButtonSegment(
                                  value: TipoRelatorioEmprestimos.atrasados,
                                  label: Text('Atrasados'),
                                  icon: Icon(Icons.warning_amber_outlined),
                                ),
                              ],
                              selected: {_tipo},
                              onSelectionChanged: (selecao) {
                                setState(() => _tipo = selecao.first);
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 320,
                              child:
                                  DropdownButtonFormField<
                                    OrdenacaoRelatorioEmprestimos
                                  >(
                                    initialValue: _ordenacao,
                                    decoration: const InputDecoration(
                                      labelText: 'Ordenar por',
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: OrdenacaoRelatorioEmprestimos
                                            .dataEmprestimo,
                                        child: Text('Data do empréstimo'),
                                      ),
                                      DropdownMenuItem(
                                        value:
                                            OrdenacaoRelatorioEmprestimos.aluno,
                                        child: Text('Nome do aluno'),
                                      ),
                                      DropdownMenuItem(
                                        value:
                                            OrdenacaoRelatorioEmprestimos.serie,
                                        child: Text('Série'),
                                      ),
                                    ],
                                    onChanged: (ordenacao) {
                                      if (ordenacao != null) {
                                        setState(() => _ordenacao = ordenacao);
                                      }
                                    },
                                  ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '${selecionados.length} registro(s) serão incluídos.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: _gerando || selecionados.isEmpty
                                  ? null
                                  : () => _gerar(
                                      emprestimos,
                                      configuracoes?[ConfigKeys.nomeEscola],
                                    ),
                              icon: _gerando
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.picture_as_pdf_outlined),
                              label: const Text('Gerar e abrir PDF'),
                            ),
                          ],
                        ),
                      ),
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

  Future<void> _gerar(List<Emprestimo> emprestimos, String? nomeEscola) async {
    setState(() => _gerando = true);
    try {
      await _service.gerarEabrir(
        emprestimos: emprestimos,
        tipo: _tipo,
        ordenacao: _ordenacao,
        nomeEscola: nomeEscola,
      );
      if (mounted) {
        showAppSnackBar(context, 'PDF gerado e aberto com sucesso.');
      }
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context, 'Erro ao gerar PDF: $e', erro: true);
      }
    } finally {
      if (mounted) {
        setState(() => _gerando = false);
      }
    }
  }
}
