import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/features/central/presentation/widgets/current_cycle_section.dart';
import 'package:webfunds/services/database/app_database.dart';

void main() {
  Future<void> pumpSection(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: CurrentCycleSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Same Drift watch-query teardown timer as accounts_page_test.dart.
  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  }

  testWidgets('prompts to start a cycle when none is active', (tester) async {
    await pumpSection(tester);

    expect(find.text('Nenhum ciclo financeiro ativo'), findsOneWidget);

    await disposeCleanly(tester);
  });

  testWidgets('starting a cycle shows it as active, closing it returns to the prompt',
      (tester) async {
    await pumpSection(tester);

    await tester.tap(find.widgetWithText(TextButton, 'Iniciar ciclo'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nome (opcional)'), 'Ciclo de Teste');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar ciclo'));
    await tester.pumpAndSettle();

    expect(find.text('Ciclo de Teste'), findsOneWidget);
    expect(find.text('Nenhum ciclo financeiro ativo'), findsNothing);

    await tester.tap(find.widgetWithText(TextButton, 'Fechar ciclo'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Fechar ciclo'));
    await tester.pumpAndSettle();

    expect(find.text('Ciclo de Teste'), findsNothing);
    expect(find.text('Nenhum ciclo financeiro ativo'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
