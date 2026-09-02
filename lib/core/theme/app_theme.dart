import 'package:flutter/material.dart';

/// Tema visual da aplicação: paleta clean e profissional, adequada a uma
/// biblioteca escolar, com componentes dimensionados para uso desktop
/// (botões e áreas de toque maiores que o padrão mobile).
class AppTheme {
  AppTheme._();

  static const Color _primary = Color(0xFF176B68);

  static ThemeData get light {
    const ColorScheme scheme = ColorScheme.light(
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD8EEEB),
      onPrimaryContainer: Color(0xFF073E3C),
      secondary: Color(0xFFC45F3E),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFE2D8),
      onSecondaryContainer: Color(0xFF512011),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: Color(0xFFF8FAF9),
      onSurface: Color(0xFF1B2625),
      onSurfaceVariant: Color(0xFF566461),
      outline: Color(0xFF657773),
      outlineVariant: Color(0xFFAEBDB9),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFEFF4F2),
      surfaceContainer: Color(0xFFE5EEEB),
      surfaceContainerHigh: Color(0xFFD8E5E1),
      surfaceContainerHighest: Color(0xFFC9DAD6),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFE6EEEB),
      visualDensity: VisualDensity.compact,
      fontFamily: 'Segoe UI',
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 15),
        bodyMedium: TextStyle(fontSize: 14),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF173E3C),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(120, 46),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(120, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(88, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F7F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: const TextStyle(
          color: _primary,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: const Color(0x33173E3C),
        color: const Color(0xFFF5F8F7),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(scheme.surfaceContainerHighest),
        headingTextStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        dataTextStyle: TextStyle(color: scheme.onSurface, fontSize: 13),
        dataRowMinHeight: 48,
        dataRowMaxHeight: 54,
        dividerThickness: 1,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurfaceVariant,
          hoverColor: scheme.primaryContainer,
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: const WidgetStatePropertyAll(true),
        thickness: const WidgetStatePropertyAll(7),
        radius: const Radius.circular(4),
        thumbColor: WidgetStatePropertyAll(
          scheme.outline.withValues(alpha: 0.55),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
  }
}
