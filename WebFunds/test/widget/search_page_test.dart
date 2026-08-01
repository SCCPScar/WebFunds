import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/features/search/presentation/pages/search_page.dart';
import 'package:webfunds/services/database/app_database.dart';

void main() {
  late AppDatabase database;

  Future<void> pumpSearchPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: SearchPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Same Drift watch-query teardown timer as every other Drift-backed
  // widget test in this suite.
  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  testWidgets('shows a hint before any query is typed', (tester) async {
    await pumpSearchPage(tester);

    expect(find.textContaining('Tudo numa só pesquisa'), findsOneWidget);

    await disposeCleanly(tester);
  });

  testWidgets('typing a merchant finds the matching Transaction after the debounce',
      (tester) async {
    await database.into(database.transactions).insert(
          TransactionRow(
            id: 'transaction-1',
            financialCycleId: 'cycle-1',
            accountId: 'account-1',
            type: 'expense',
            amountMinorUnits: 2000,
            amountCurrency: '€',
            transactionDate: DateTime(2026, 1, 5),
            merchant: 'Continente',
            category: 'Groceries',
            createdAt: DateTime(2026, 1, 5),
            updatedAt: DateTime(2026, 1, 5),
          ),
        );

    await pumpSearchPage(tester);

    await tester.enterText(find.byType(TextField), 'continente');
    // The debounce is 250ms — pump past it before settling.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Transações'), findsOneWidget);
    expect(find.text('Continente'), findsOneWidget);

    await disposeCleanly(tester);
  });

  testWidgets('a query matching nothing shows the empty-results state', (tester) async {
    await pumpSearchPage(tester);

    await tester.enterText(find.byType(TextField), 'does-not-exist');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.textContaining('Sem resultados'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
