import 'package:flutter/material.dart';

/// Tema visual da aplicação: paleta clean e profissional, adequada a uma
/// biblioteca escolar, com componentes dimensionados para uso desktop
/// (botões e áreas de toque maiores que o padrão mobile).
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF2C5F7C);

  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF5F7F8),
      visualDensity: VisualDensity.standard,
      fontFamily: 'Segoe UI',
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 15),
        bodyMedium: TextStyle(fontSize: 14),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface,
        selectedIconTheme: IconThemeData(color: scheme.primary),
        selectedLabelTextStyle: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: const TextStyle(fontWeight: FontWeight.w400),
        indicatorColor: scheme.primaryContainer,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(120, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
        fillColor: scheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
        dataRowMinHeight: 46,
        dataRowMaxHeight: 52,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
