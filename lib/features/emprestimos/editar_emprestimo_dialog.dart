import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../core/utils/domain_exception.dart';
import '../../shared/widgets/suggest_field.dart';

/// Diálogo para corrigir aluno, livro e turma de um empréstimo já lançado.
Future<bool> showEditarEmprestimoDialog(
  BuildContext context,
  WidgetRef ref,
  Emprestimo item,
) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (context) => _EditarEmprestimoDialog(item: item),
  );
  return resultado ?? false;
}

class _EditarEmprestimoDialog extends ConsumerStatefulWidget {
  const _EditarEmprestimoDialog({required this.item});

  final Emprestimo item;

  @override
  ConsumerState<_EditarEmprestimoDialog> createState() =>
      _EditarEmprestimoDialogState();
}

class _EditarEmprestimoDialogState
    extends ConsumerState<_EditarEmprestimoDialog> {
  late final _alunoController = TextEditingController(
    text: widget.item.alunoNome,
  );
  late final _livroController = TextEditingController(
    text: widget.item.livroTitulo,
  );
  String? _erro;
  late final _serieController = TextEditingController(
    text: widget.item.serie.toString(),
  );
  late final _turmaController = TextEditingController(
    text: widget.item.turmaLetra,
  );
  bool _salvando = false;

  @override
  void dispose() {
    _alunoController.dispose();
    _livroController.dispose();
    _serieController.dispose();
    _turmaController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    setState(() {
      _erro = null;
      _salvando = true;
    });
    try {
      await ref
          .read(emprestimoServiceProvider)
          .editarEmprestimo(
            widget.item.id,
            alunoNome: _alunoController.text,
            livroTitulo: _livroController.text,
            serie: int.tryParse(_serieController.text.trim()) ?? 0,
            turmaLetra: _turmaController.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on DomainException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.message;
        _salvando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(emprestimoRepositoryProvider);
    return AlertDialog(
      title: const Text('Editar empréstimo'),
      scrollable: true,
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SuggestField(
              controller: _alunoController,
              labelText: 'Nome do aluno',
              fetchSuggestions: repo.sugerirAlunos,
            ),
            const SizedBox(height: 16),
            SuggestField(
              controller: _livroController,
              labelText: 'Título do livro',
              fetchSuggestions: repo.sugerirLivros,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _serieController,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Série',
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _turmaController,
                    maxLength: 1,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.toUpperCase(),
                        ),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Turma',
                      counterText: '',
                    ),
                  ),
                ),
              ],
            ),
            if (_erro != null) ...[
              const SizedBox(height: 12),
              Text(
                _erro!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _salvando ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _salvando ? null : _salvar,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
