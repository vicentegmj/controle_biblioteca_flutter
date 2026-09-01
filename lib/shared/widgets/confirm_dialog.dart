import 'package:flutter/material.dart';

/// Exibe uma confirmação padrão antes de operações importantes/irreversíveis.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  String textoConfirmar = 'Confirmar',
  String textoCancelar = 'Cancelar',
  bool destrutivo = false,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(textoCancelar),
        ),
        FilledButton(
          style: destrutivo
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(textoConfirmar),
        ),
      ],
    ),
  );
  return resultado ?? false;
}
