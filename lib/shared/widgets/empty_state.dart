import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.mensagem, this.icone = Icons.inbox_outlined});

  final String mensagem;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 48, color: scheme.outline),
          const SizedBox(height: 12),
          Text(
            mensagem,
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
