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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: Theme.of(context).textTheme.titleLarge),
              if (subtitulo != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitulo!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
        ...actions,
      ],
    );
  }
}
