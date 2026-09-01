import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';

const List<String> kTurnos = ['Matutino', 'Vespertino', 'Noturno', 'Integral'];

/// Diálogo de criação/edição de turma.
class TurmaFormDialog extends ConsumerStatefulWidget {
  const TurmaFormDialog({super.key, this.turma});

  final Turma? turma;

  @override
  ConsumerState<TurmaFormDialog> createState() => _TurmaFormDialogState();
}

class _TurmaFormDialogState extends ConsumerState<TurmaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _serieController;
  late final TextEditingController _anoLetivoController;
  String _turno = kTurnos.first;
  bool _salvando = false;

  bool get _editando => widget.turma != null;

  @override
  void initState() {
    super.initState();
    final t = widget.turma;
    _nomeController = TextEditingController(text: t?.nome ?? '');
    _serieController = TextEditingController(text: t?.serie ?? '');
    _anoLetivoController = TextEditingController(
      text: (t?.anoLetivo ?? DateTime.now().year).toString(),
    );
    _turno = t?.turno ?? kTurnos.first;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _serieController.dispose();
    _anoLetivoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      final repo = ref.read(turmaRepositoryProvider);
      final anoLetivo = int.parse(_anoLetivoController.text.trim());
      if (_editando) {
        await repo.update(
          widget.turma!.copyWith(
            nome: _nomeController.text.trim(),
            serie: _serieController.text.trim(),
            turno: _turno,
            anoLetivo: anoLetivo,
          ),
        );
      } else {
        await repo.create(
          TurmasCompanion.insert(
            nome: _nomeController.text.trim(),
            serie: _serieController.text.trim(),
            turno: _turno,
            anoLetivo: anoLetivo,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar turma: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editando ? 'Editar Turma' : 'Nova Turma'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomeController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nome da turma *',
                  hintText: 'Ex.: 6º Ano A',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _serieController,
                decoration: const InputDecoration(
                  labelText: 'Série/Ano *',
                  hintText: 'Ex.: 6º Ano',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a série' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _turno,
                      decoration: const InputDecoration(labelText: 'Turno *'),
                      items: kTurnos
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => _turno = v ?? _turno),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _anoLetivoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Ano letivo *'),
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n < 2000 || n > 2100) {
                          return 'Ano inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
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
