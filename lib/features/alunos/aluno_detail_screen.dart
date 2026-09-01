import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_formatters.dart';
import '../../models/emprestimo_item_detalhado.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/status_badge.dart';
import 'alunos_providers.dart';

/// Detalhe do aluno: dados cadastrais e histórico completo de empréstimos
/// (seção 13 do escopo).
class AlunoDetailScreen extends ConsumerWidget {
  const AlunoDetailScreen({super.key, required this.alunoId});

  final int alunoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alunoAsync = ref.watch(alunoDetalheProvider(alunoId));
    final historicoAsync = ref.watch(historicoAlunoProvider(alunoId));

    return Scaffold(
      appBar: AppBar(
        title: alunoAsync.maybeWhen(
          data: (ac) => Text(ac?.aluno.nome ?? 'Aluno'),
          orElse: () => const Text('Aluno'),
        ),
      ),
      body: alunoAsync.when(
        data: (ac) {
          if (ac == null) {
            return const EmptyState(mensagem: 'Aluno não encontrado.');
          }
          return Padding(
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
                        _infoTile('Matrícula', ac.aluno.matricula ?? '-'),
                        _infoTile('Turma', ac.turma.nome),
                        _infoTile(
                          'Nascimento',
                          formatDate(ac.aluno.dataNascimento),
                        ),
                        _infoTile(
                          'Telefone do responsável',
                          ac.aluno.telefoneResponsavel ?? '-',
                        ),
                        _infoTile('Status', ac.aluno.ativo ? 'Ativo' : 'Inativo'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                historicoAsync.maybeWhen(
                  data: (historico) => _buildResumo(context, historico),
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                Text('Histórico de empréstimos',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Expanded(
                  child: historicoAsync.when(
                    data: (historico) {
                      if (historico.isEmpty) {
                        return const EmptyState(
                          mensagem: 'Este aluno ainda não possui empréstimos.',
                        );
                      }
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Livro')),
                              DataColumn(label: Text('Exemplar')),
                              DataColumn(label: Text('Empréstimo')),
                              DataColumn(label: Text('Previsto')),
                              DataColumn(label: Text('Devolvido')),
                              DataColumn(label: Text('Situação')),
                            ],
                            rows: historico
                                .map(
                                  (h) => DataRow(
                                    cells: [
                                      DataCell(Text(h.livro.titulo)),
                                      DataCell(Text(h.exemplar.codigo)),
                                      DataCell(
                                          Text(formatDate(h.emprestimo.dataEmprestimo))),
                                      DataCell(Text(
                                          formatDate(h.emprestimo.dataPrevistaDevolucao))),
                                      DataCell(Text(formatDate(h.item.dataDevolucao))),
                                      DataCell(_situacaoBadge(h)),
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
                      mensagem: 'Erro ao carregar histórico: $e',
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          );
        },
        error: (e, st) => EmptyState(
          icone: Icons.error_outline,
          mensagem: 'Erro ao carregar aluno: $e',
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildResumo(BuildContext context, List<EmprestimoItemDetalhado> historico) {
    final total = historico.length;
    final emAberto = historico.where((h) => h.emAberto).length;
    final atrasados = historico.where((h) => h.atrasado).length;
    return Row(
      children: [
        Expanded(child: _resumoCard(context, 'Total de empréstimos', '$total')),
        const SizedBox(width: 12),
        Expanded(child: _resumoCard(context, 'Em aberto', '$emAberto')),
        const SizedBox(width: 12),
        Expanded(child: _resumoCard(context, 'Atrasados', '$atrasados')),
      ],
    );
  }

  Widget _resumoCard(BuildContext context, String titulo, String valor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(valor, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
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

  Widget _situacaoBadge(EmprestimoItemDetalhado h) {
    if (h.emprestimo.status.name == 'cancelado') {
      return const StatusBadge(texto: 'Cancelado', tone: BadgeTone.neutral);
    }
    if (h.devolvido) {
      return const StatusBadge(texto: 'Devolvido', tone: BadgeTone.success);
    }
    if (h.atrasado) {
      return StatusBadge(texto: 'Atrasado (${h.diasAtraso}d)', tone: BadgeTone.danger);
    }
    return const StatusBadge(texto: 'Em aberto', tone: BadgeTone.info);
  }
}
