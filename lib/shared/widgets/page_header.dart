import 'package:flutter/material.dart';

/// Cabeçalho padrão das telas: título, subtítulo opcional e ações à direita
/// (botões de novo cadastro, filtros etc.).
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.actions = const [],
  });

  final String titulo;
  final String? subtitulo;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.secondary, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: theme.textTheme.titleLarge),
                if (subtitulo != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitulo!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
