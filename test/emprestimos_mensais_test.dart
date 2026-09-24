import 'package:controle_biblioteca/core/database/database.dart';
import 'package:controle_biblioteca/features/dashboard/dashboard_providers.dart';
import 'package:controle_biblioteca/features/dashboard/emprestimos_chart.dart';
import 'package:controle_biblioteca/features/dashboard/emprestimos_mensais.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Emprestimo item(
  DateTime data, [
  StatusEmprestimo status = StatusEmprestimo.aberto,
]) => Emprestimo(
  id: 1,
  alunoNome: 'Aluno',
  serie: 6,
  turmaLetra: 'A',
  anoLetivo: data.year,
  livroTitulo: 'Livro',
  dataEmprestimo: data,
  dataPrevistaDevolucao: data.add(const Duration(days: 7)),
  status: status,
  createdAt: data,
  updatedAt: data,
);

void main() {
  test('Agrupa por mês entre anos, preenche zeros e exclui cancelados e fora do período', () {
    final resultado = agruparEmprestimosPorMes(
      [
        item(DateTime(2025, 11, 30)),
        item(DateTime(2025, 12, 1)),
        item(DateTime(2025, 12, 31), StatusEmprestimo.devolvido),
        item(DateTime(2026, 1, 1), StatusEmprestimo.cancelado),
        item(DateTime(2026, 2, 28)),
        item(DateTime(2026, 3, 1)),
      ],
      referencia: DateTime(2026, 2, 28),
      meses: 3,
    );
    expect(resultado.map((e) => e.quantidade), [2, 0, 1]);
    expect(resultado.map((e) => e.mes), [
      DateTime(2025, 12),
      DateTime(2026, 1),
      DateTime(2026, 2),
    ]);
  });

  testWidgets('Mostra período vazio e troca o intervalo em tela estreita', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          emprestimosMensaisProvider.overrideWith(
            (ref, meses) => AsyncData(
              agruparEmprestimosPorMes(
                [],
                referencia: DateTime(2026, 2),
                meses: meses,
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: EmprestimosChart())),
      ),
    );
    expect(
      find.text('Nenhum empréstimo registrado neste período.'),
      findsOneWidget,
    );
    expect(find.text('0'), findsNWidgets(12));
    await tester.tap(find.text('6 meses'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNWidgets(6));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    '24 meses mantém os dados recentes visíveis e permite ver os antigos',
    (tester) async {
      tester.view.physicalSize = const Size(900, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            emprestimosMensaisProvider.overrideWith(
              (ref, meses) => AsyncData(
                agruparEmprestimosPorMes(
                  [
                    item(DateTime(2026, 2, 1)),
                    item(DateTime(2024, 3, 1)),
                    item(DateTime(2024, 3, 2)),
                  ],
                  referencia: DateTime(2026, 2),
                  meses: meses,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: EmprestimosChart())),
        ),
      );
      await tester.tap(find.text('24 meses'));
      await tester.pumpAndSettle();
      expect(find.text('3 empréstimo(s) no período'), findsOneWidget);
      expect(find.text('1').hitTestable(), findsOneWidget);
      expect(find.text('2').hitTestable(), findsNothing);
      final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar).first);
      expect(scrollbar.thumbVisibility, isTrue);
      scrollbar.controller!.jumpTo(
        scrollbar.controller!.position.maxScrollExtent,
      );
      await tester.pumpAndSettle();
      expect(find.text('2').hitTestable(), findsOneWidget);
      await tester.tap(find.text('6 meses'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('24 meses'));
      await tester.pumpAndSettle();
      expect(find.text('1').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
