import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_shell.dart';
import 'core/database/repository_providers.dart';
import 'core/theme/app_theme.dart';
import 'services/log_service.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final logService = await LogService.instance();

      FlutterError.onError = (FlutterErrorDetails details) {
        logService.registrarErro(
          'FlutterError',
          details.exception,
          details.stack,
        );
        FlutterError.presentError(details);
      };

      runApp(
        ProviderScope(
          overrides: [
            logServiceProvider.overrideWithValue(logService),
          ],
          child: const BibliotecaApp(),
        ),
      );
    },
    (error, stack) async {
      final logService = await LogService.instance();
      await logService.registrarErro('Erro não tratado', error, stack);
    },
  );
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Escolar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}
