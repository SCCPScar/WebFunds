import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/features/dreams/presentation/pages/dreams_page.dart';
import 'package:webfunds/services/database/app_database.dart';

void main() {
  Future<void> pumpDreamsPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
        ],
        child: const MaterialApp(home: DreamsPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Same Drift watch-query teardown timer as accounts_page_test.dart.
  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  }

  testWidgets('shows the empty state before any Dream exists', (tester) async {
    await pumpDreamsPage(tester);

    expect(find.textContaining('Ainda não tens objetivos'), findsOneWidget);

    await disposeCleanly(tester);
  });

  testWidgets('creating a Dream through the form makes it appear in the list', (tester) async {
    await pumpDreamsPage(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nome'), 'Laptop novo');
    await tester.enterText(find.widgetWithText(TextFormField, 'Valor alvo'), '1000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Criar objetivo'));
    await tester.pumpAndSettle();

    expect(find.text('Laptop novo'), findsOneWidget);
    expect(find.textContaining('Ainda não tens objetivos'), findsNothing);

    await disposeCleanly(tester);
  });

  testWidgets('contributing to a Dream updates its progress', (tester) async {
    await pumpDreamsPage(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Nome'), 'Férias');
    await tester.enterText(find.widgetWithText(TextFormField, 'Valor alvo'), '200');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Criar objetivo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Férias'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Contribuir'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Valor'), '50');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Contribuir').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('€ 50.00 de € 200.00 reservado'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
