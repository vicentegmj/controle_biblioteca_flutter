import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../repositories/aluno_repository.dart';
import '../../shared/widgets/app_search_field.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/status_badge.dart';
import '../turmas/turmas_providers.dart';
import 'aluno_detail_screen.dart';
import 'aluno_form_dialog.dart';
import 'alunos_providers.dart';

class AlunosScreen extends ConsumerStatefulWidget {
  const AlunosScreen({super.key});

  @override
  ConsumerState<AlunosScreen> createState() => _AlunosScreenState();
}

class _AlunosScreenState extends ConsumerState<AlunosScreen> {
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _abrirFormulario([Aluno? aluno]) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => AlunoFormDialog(aluno: aluno),
    );
  }

  Future<void> _abrirDetalhe(int alunoId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AlunoDetailScreen(alunoId: alunoId)),
    );
  }

  Future<void> _alternarAtivo(Aluno aluno) async {
    if (aluno.ativo) {
      final confirmado = await showConfirmDialog(
        context,
        titulo: 'Inativar aluno',
        mensagem:
            'Deseja inativar "${aluno.nome}"? Alunos inativos não podem '
            'realizar novos empréstimos, mas o histórico é preservado.',
      );
      if (!confirmado) return;
    }
    await ref.read(alunoRepositoryProvider).setAtivo(aluno.id, !aluno.ativo);
  }

  @override
  Widget build(BuildContext context) {
    final alunosAsync = ref.watch(alunosListProvider);
    final filtro = ref.watch(alunosFiltroProvider);
    final turmasAsync = ref.watch(turmasListProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            titulo: 'Alunos',
            subtitulo: 'Cadastro de alunos da biblioteca',
            actions: [
              FilledButton.icon(
                onPressed: () => _abrirFormulario(),
                icon: const Icon(Icons.add),
                label: const Text('Novo Aluno'),
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
                hintText: 'Buscar por nome ou matrícula...',
                onChanged: (v) => ref
                    .read(alunosFiltroProvider.notifier)
                    .update((s) => s.copyWith(busca: v)),
              ),
              turmasAsync.maybeWhen(
                data: (turmas) => SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<int?>(
                    initialValue: filtro.turmaId,
                    isDense: true,
                    decoration: const InputDecoration(labelText: 'Turma'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas')),
                      ...turmas.map(
                        (t) => DropdownMenuItem(value: t.id, child: Text(t.nome)),
                      ),
                    ],
                    onChanged: (v) => ref
                        .read(alunosFiltroProvider.notifier)
                        .update((s) => s.copyWith(turmaId: () => v)),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
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
                      .read(alunosFiltroProvider.notifier)
                      .update((s) => s.copyWith(ativo: () => v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: alunosAsync.when(
              data: (alunos) {
                if (alunos.isEmpty) {
                  return const EmptyState(mensagem: 'Nenhum aluno encontrado.');
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nome')),
                        DataColumn(label: Text('Matrícula')),
                        DataColumn(label: Text('Turma')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Ações')),
                      ],
                      rows: alunos
                          .map((ac) => _buildRow(ac))
                          .toList(growable: false),
                    ),
                  ),
                );
              },
              error: (e, st) => EmptyState(
                icone: Icons.error_outline,
                mensagem: 'Erro ao carregar alunos: $e',
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(AlunoComTurma ac) {
    final aluno = ac.aluno;
    return DataRow(
      onSelectChanged: (_) => _abrirDetalhe(aluno.id),
      cells: [
        DataCell(Text(aluno.nome)),
        DataCell(Text(aluno.matricula ?? '-')),
        DataCell(Text(ac.turma.nome)),
        DataCell(
          StatusBadge(
            texto: aluno.ativo ? 'Ativo' : 'Inativo',
            tone: aluno.ativo ? BadgeTone.success : BadgeTone.neutral,
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Histórico',
                icon: const Icon(Icons.history),
                onPressed: () => _abrirDetalhe(aluno.id),
              ),
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _abrirFormulario(aluno),
              ),
              IconButton(
                tooltip: aluno.ativo ? 'Inativar' : 'Ativar',
                icon: Icon(
                  aluno.ativo
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => _alternarAtivo(aluno),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
