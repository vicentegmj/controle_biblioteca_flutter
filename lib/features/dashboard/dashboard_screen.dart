import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_formatters.dart';
import '../../core/utils/turma_utils.dart';
import '../../models/emprestimo_extensions.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import '../configuracoes/configuracoes_providers.dart';
import 'dashboard_providers.dart';

/// Tela inicial com indicadores essenciais (seção 13). Sem gráficos —
/// apenas números e uma lista curta de devoluções mais atrasadas.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicadoresAsync = ref.watch(dashboardIndicadoresProvider);
    final configAsync = ref.watch(configuracaoStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            titulo: 'Dashboard',
            subtitulo: configAsync.maybeWhen(
              data: (config) => config['nome_escola'],
              orElse: () => null,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: indicadoresAsync.when(
              data: (dados) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _cardIndicador(
                          context,
                          titulo: 'Empréstimos em aberto',
                          valor: '${dados.emAberto}',
                          icone: Icons.folder_open,
                          tone: BadgeTone.info,
                        ),
                        _cardIndicador(
                          context,
                          titulo: 'Empréstimos atrasados',
                          valor: '${dados.atrasados}',
                          icone: Icons.warning_amber,
                          tone: BadgeTone.danger,
                        ),
                        _cardIndicador(
                          context,
                          titulo: 'Empréstimos hoje',
                          valor: '${dados.emprestimosHoje}',
                          icone: Icons.add_box,
                          tone: BadgeTone.success,
                        ),
                        _cardIndicador(
                          context,
                          titulo: 'Devoluções hoje',
                          valor: '${dados.devolucoesHoje}',
                          icone: Icons.assignment_return,
                          tone: BadgeTone.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text('Devoluções atrasadas', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    if (dados.devolucoesAtrasadasOrdenadas.isEmpty)
                      const EmptyState(
                        mensagem: 'Nenhuma devolução atrasada no momento. 🎉',
                        icone: Icons.check_circle_outline,
                      )
                    else
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: dados.devolucoesAtrasadasOrdenadas.take(10).map((item) {
                            return ListTile(
                              leading: const Icon(Icons.menu_book_outlined),
                              title: Text('${item.livroTitulo} — ${item.alunoNome}'),
                              subtitle: Text(
                                '${TurmaUtils.rotulo(item.serie, item.turmaLetra)} · '
                                'Previsto: ${formatDate(item.dataPrevistaDevolucao)}',
                              ),
                              trailing: StatusBadge(
                                texto: '${item.diasAtraso} dia(s)',
                                tone: BadgeTone.danger,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              error: (e, st) => EmptyState(
                icone: Icons.error_outline,
                mensagem: 'Erro ao carregar indicadores: $e',
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardIndicador(
    BuildContext context, {
    required String titulo,
    required String valor,
    required IconData icone,
    required BadgeTone tone,
  }) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icone, size: 28),
              const SizedBox(height: 12),
              Text(valor, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28)),
              const SizedBox(height: 4),
              Text(titulo, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
