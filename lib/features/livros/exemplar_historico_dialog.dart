import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
import '../../core/utils/date_formatters.dart';
import '../../models/emprestimo_item_detalhado.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/status_badge.dart';

/// Histórico de empréstimos de um exemplar específico (seção 14 do escopo).
class ExemplarHistoricoDialog extends ConsumerWidget {
  const ExemplarHistoricoDialog({
    super.key,
    required this.exemplarId,
    required this.codigoExemplar,
  });

  final int exemplarId;
  final String codigoExemplar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historicoAsync = ref.watch(
      _historicoExemplarProvider(exemplarId),
    );

    return AlertDialog(
      title: Text('Histórico do exemplar $codigoExemplar'),
      content: SizedBox(
        width: 600,
        height: 400,
        child: historicoAsync.when(
          data: (historico) {
            if (historico.isEmpty) {
              return const EmptyState(
                mensagem: 'Este exemplar ainda não foi emprestado.',
              );
            }
            return SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Aluno')),
                  DataColumn(label: Text('Turma')),
                  DataColumn(label: Text('Empréstimo')),
                  DataColumn(label: Text('Previsto')),
                  DataColumn(label: Text('Devolvido')),
                ],
                rows: historico
                    .map(
                      (h) => DataRow(
                        cells: [
                          DataCell(Text(h.aluno.nome)),
                          DataCell(Text(h.turma.nome)),
                          DataCell(Text(formatDate(h.emprestimo.dataEmprestimo))),
                          DataCell(Text(formatDate(h.emprestimo.dataPrevistaDevolucao))),
                          DataCell(
                            h.devolvido
                                ? Text(formatDate(h.item.dataDevolucao))
                                : const StatusBadge(
                                    texto: 'Em aberto', tone: BadgeTone.info),
                          ),
                        ],
                      ),
                    )
                    .toList(),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

final _historicoExemplarProvider =
    FutureProvider.family<List<EmprestimoItemDetalhado>, int>((ref, exemplarId) {
  return ref.watch(emprestimoRepositoryProvider).getHistoricoExemplar(exemplarId);
});
