import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../core/utils/date_formatters.dart';
import '../turmas/turmas_providers.dart';

/// Diálogo de criação/edição de aluno.
class AlunoFormDialog extends ConsumerStatefulWidget {
  const AlunoFormDialog({super.key, this.aluno});

  final Aluno? aluno;

  @override
  ConsumerState<AlunoFormDialog> createState() => _AlunoFormDialogState();
}

class _AlunoFormDialogState extends ConsumerState<AlunoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _matriculaController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _observacoesController;
  int? _turmaId;
  DateTime? _dataNascimento;
  bool _salvando = false;

  bool get _editando => widget.aluno != null;

  @override
  void initState() {
    super.initState();
    final a = widget.aluno;
    _nomeController = TextEditingController(text: a?.nome ?? '');
    _matriculaController = TextEditingController(text: a?.matricula ?? '');
    _telefoneController = TextEditingController(text: a?.telefoneResponsavel ?? '');
    _observacoesController = TextEditingController(text: a?.observacoes ?? '');
    _turmaId = a?.turmaId;
    _dataNascimento = a?.dataNascimento;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _matriculaController.dispose();
    _telefoneController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _escolherDataNascimento() async {
    final agora = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime(agora.year - 10),
      firstDate: DateTime(agora.year - 100),
      lastDate: agora,
    );
    if (data != null) setState(() => _dataNascimento = data);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_turmaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a turma do aluno.')),
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      final repo = ref.read(alunoRepositoryProvider);
      final matricula = _matriculaController.text.trim();

      if (matricula.isNotEmpty) {
        final emUso = await repo.matriculaEmUso(
          matricula,
          ignorandoId: widget.aluno?.id,
        );
        if (emUso) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Esta matrícula já está em uso.')),
            );
            setState(() => _salvando = false);
          }
          return;
        }
      }

      final observacoes = _observacoesController.text.trim();
      final telefone = _telefoneController.text.trim();

      if (_editando) {
        await repo.update(
          widget.aluno!.copyWith(
            nome: _nomeController.text.trim(),
            matricula: Value(matricula.isEmpty ? null : matricula),
            turmaId: _turmaId!,
            dataNascimento: Value(_dataNascimento),
            telefoneResponsavel: Value(telefone.isEmpty ? null : telefone),
            observacoes: Value(observacoes.isEmpty ? null : observacoes),
          ),
        );
      } else {
        await repo.create(
          AlunosCompanion.insert(
            nome: _nomeController.text.trim(),
            matricula: Value(matricula.isEmpty ? null : matricula),
            turmaId: _turmaId!,
            dataNascimento: Value(_dataNascimento),
            telefoneResponsavel: Value(telefone.isEmpty ? null : telefone),
            observacoes: Value(observacoes.isEmpty ? null : observacoes),
          ),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar aluno: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final turmasAsync = ref.watch(turmasListProvider);

    return AlertDialog(
      title: Text(_editando ? 'Editar Aluno' : 'Novo Aluno'),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nomeController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Nome completo *'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _matriculaController,
                        decoration: const InputDecoration(
                          labelText: 'Matrícula',
                          hintText: 'Opcional, deve ser única',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: turmasAsync.when(
                        data: (turmas) => DropdownButtonFormField<int>(
                          initialValue: turmas.any((t) => t.id == _turmaId)
                              ? _turmaId
                              : null,
                          decoration: const InputDecoration(labelText: 'Turma *'),
                          items: turmas
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t.id,
                                  child: Text(t.nome),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _turmaId = v),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, st) => Text('Erro ao carregar turmas: $e'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _escolherDataNascimento,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Data de nascimento',
                          ),
                          child: Text(
                            _dataNascimento == null
                                ? 'Não informada'
                                : formatDate(_dataNascimento),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _telefoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone do responsável',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _observacoesController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Observações'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _salvando ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _salvando ? null : _salvar,
          child: _salvando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }
}
