import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';

/// Diálogo de criação/edição do cadastro bibliográfico (título).
class LivroFormDialog extends ConsumerStatefulWidget {
  const LivroFormDialog({super.key, this.livro});

  final Livro? livro;

  @override
  ConsumerState<LivroFormDialog> createState() => _LivroFormDialogState();
}

class _LivroFormDialogState extends ConsumerState<LivroFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _autorController;
  late final TextEditingController _editoraController;
  late final TextEditingController _isbnController;
  late final TextEditingController _categoriaController;
  late final TextEditingController _observacoesController;
  bool _salvando = false;

  bool get _editando => widget.livro != null;

  @override
  void initState() {
    super.initState();
    final l = widget.livro;
    _tituloController = TextEditingController(text: l?.titulo ?? '');
    _autorController = TextEditingController(text: l?.autor ?? '');
    _editoraController = TextEditingController(text: l?.editora ?? '');
    _isbnController = TextEditingController(text: l?.isbn ?? '');
    _categoriaController = TextEditingController(text: l?.categoria ?? '');
    _observacoesController = TextEditingController(text: l?.observacoes ?? '');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _editoraController.dispose();
    _isbnController.dispose();
    _categoriaController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      final repo = ref.read(livroRepositoryProvider);
      String? nullIfEmpty(String v) => v.trim().isEmpty ? null : v.trim();

      if (_editando) {
        await repo.update(
          widget.livro!.copyWith(
            titulo: _tituloController.text.trim(),
            autor: _autorController.text.trim(),
            editora: Value(nullIfEmpty(_editoraController.text)),
            isbn: Value(nullIfEmpty(_isbnController.text)),
            categoria: Value(nullIfEmpty(_categoriaController.text)),
            observacoes: Value(nullIfEmpty(_observacoesController.text)),
          ),
        );
      } else {
        await repo.create(
          LivrosCompanion.insert(
            titulo: _tituloController.text.trim(),
            autor: _autorController.text.trim(),
            editora: Value(nullIfEmpty(_editoraController.text)),
            isbn: Value(nullIfEmpty(_isbnController.text)),
            categoria: Value(nullIfEmpty(_categoriaController.text)),
            observacoes: Value(nullIfEmpty(_observacoesController.text)),
          ),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar livro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editando ? 'Editar Livro' : 'Novo Livro'),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Título *'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _autorController,
                  decoration: const InputDecoration(labelText: 'Autor *'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Informe o autor' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _editoraController,
                        decoration: const InputDecoration(labelText: 'Editora'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _isbnController,
                        decoration: const InputDecoration(labelText: 'ISBN'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoria'),
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
