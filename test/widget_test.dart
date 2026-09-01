import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:controle_biblioteca/app_shell.dart';
import 'package:controle_biblioteca/core/database/app_database_provider.dart';
import 'package:controle_biblioteca/core/database/database.dart';
import 'package:controle_biblioteca/core/theme/app_theme.dart';

void main() {
  testWidgets('App inicia e mostra o Dashboard', (WidgetTester tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    tester.view.physicalSize = const Size(1366, 768);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(theme: AppTheme.light, home: const AppShell()),
      ),
    );
    // Não usa pumpAndSettle(): a árvore mantém várias StreamProviders (Drift)
    // vivas simultaneamente (todas as telas ficam montadas no IndexedStack),
    // e seus streams reais não são coordenados pelo relógio falso do
    // flutter_test, então pumpAndSettle nunca converge. Alguns pumps
    // limitados são suficientes para deixar o primeiro frame assentar.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Alunos'), findsWidgets);

    // Desmonta a árvore (e a ProviderScope) dentro do próprio teste, com
    // alguns pumps extras, para que os timers de limpeza que o Drift agenda
    // ao cancelar cada uma das várias streams abertas (uma por tela do
    // IndexedStack) tenham a chance de disparar antes do binding de teste
    // verificar que não sobrou nenhum timer pendente.
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 10));
    }
  });
}
