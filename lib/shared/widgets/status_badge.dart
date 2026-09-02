import 'package:flutter/material.dart';

enum BadgeTone { neutral, success, warning, danger, info }

/// Selo colorido para status (ABERTO, DEVOLVIDO, ATRASADO, ATIVO, INATIVO...).
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.texto,
    this.tone = BadgeTone.neutral,
  });

  final String texto;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color bg, Color fg) = switch (tone) {
      BadgeTone.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      BadgeTone.success => (const Color(0xFFDCF5E6), const Color(0xFF1E7A42)),
      BadgeTone.warning => (const Color(0xFFFFF3CD), const Color(0xFF8A6D00)),
      BadgeTone.danger => (const Color(0xFFFCE0E0), const Color(0xFFB3261E)),
      BadgeTone.info => (scheme.primaryContainer, scheme.onPrimaryContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: fg.withValues(alpha: 0.18)),
      ),
      child: Text(
        texto,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
