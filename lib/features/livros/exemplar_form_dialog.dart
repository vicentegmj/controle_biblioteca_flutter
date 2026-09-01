import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';

/// Diálogo de criação/edição de um exemplar físico de um livro.
class ExemplarFormDialog extends ConsumerStatefulWidget {
  const ExemplarFormDialog({super.key, required this.livroId, this.exemplar});

  final int livroId;
  final Exemplar? exemplar;

  @override
  ConsumerState<ExemplarFormDialog> createState() => _ExemplarFormDialogState();
}

class _ExemplarFormDialogState extends ConsumerState<ExemplarFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoController;
  late final TextEditingController _codigoBarrasController;
  late final TextEditingController _observacoesController;
  bool _salvando = false;

  bool get _editando => widget.exemplar != null;

  @override
  void initState() {
    super.initState();
    final e = widget.exemplar;
    _codigoController = TextEditingController(text: e?.codigo ?? '');
    _codigoBarrasController = TextEditingController(text: e?.codigoBarras ?? '');
    _observacoesController = TextEditingController(text: e?.observacoes ?? '');
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _codigoBarrasController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      final repo = ref.read(exemplarRepositoryProvider);
      final codigo = _codigoController.text.trim();
      final codigoBarras = _codigoBarrasController.text.trim();

      if (await repo.codigoEmUso(codigo, ignorandoId: widget.exemplar?.id)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este código já está em uso.')),
          );
          setState(() => _salvando = false);
        }
        return;
      }
      if (codigoBarras.isNotEmpty &&
          await repo.codigoBarrasEmUso(codigoBarras, ignorandoId: widget.exemplar?.id)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este código de barras já está em uso.')),
          );
          setState(() => _salvando = false);
        }
        return;
      }

      final observacoes = _observacoesController.text.trim();

      if (_editando) {
        await repo.update(
          widget.exemplar!.copyWith(
            codigo: codigo,
            codigoBarras: Value(codigoBarras.isEmpty ? null : codigoBarras),
            observacoes: Value(observacoes.isEmpty ? null : observacoes),
          ),
        );
      } else {
        await repo.create(
          ExemplaresCompanion.insert(
            livroId: widget.livroId,
            codigo: codigo,
            codigoBarras: Value(codigoBarras.isEmpty ? null : codigoBarras),
            observacoes: Value(observacoes.isEmpty ? null : observacoes),
          ),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar exemplar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editando ? 'Editar Exemplar' : 'Novo Exemplar'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codigoController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Código do exemplar *',
                  hintText: 'Ex.: HP0001',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o código' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codigoBarrasController,
                decoration: const InputDecoration(labelText: 'Código de barras'),
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
