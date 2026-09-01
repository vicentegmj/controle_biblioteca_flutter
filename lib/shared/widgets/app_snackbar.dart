import 'package:flutter/material.dart';

/// Feedback visual padrão (sucesso/erro) para operações do usuário.
void showAppSnackBar(
  BuildContext context,
  String mensagem, {
  bool erro = false,
}) {
  final scheme = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? scheme.error : scheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: erro ? 5 : 3),
      ),
    );
}
