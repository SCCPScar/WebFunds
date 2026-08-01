import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/features/subscriptions/presentation/pages/subscriptions_page.dart';
import 'package:webfunds/services/database/app_database.dart';

void main() {
  late AppDatabase database;

  Future<void> pumpSubscriptionsPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: SubscriptionsPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Same Drift watch-query teardown timer as other widget tests.
  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  }

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    Future<void> insertExpense(String id, DateTime date) {
      return database.into(database.transactions).insert(
            TransactionRow(
              id: id,
              financialCycleId: 'cycle-1',
              accountId: 'account-1',
              type: 'expense',
              amountMinorUnits: 1299,
              amountCurrency: '€',
              transactionDate: date,
              merchant: 'Netflix',
              createdAt: date,
              updatedAt: date,
            ),
          );
    }

    await insertExpense('t1', DateTime(2026, 1, 5));
    await insertExpense('t2', DateTime(2026, 2, 5));
    await insertExpense('t3', DateTime(2026, 3, 6));
  });

  tearDown(() => database.close());

  testWidgets('shows a detected suggestion and confirming it moves it to the active list',
      (tester) async {
    await pumpSubscriptionsPage(tester);

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Ainda não confirmaste nenhuma subscrição.'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirmar'));
    await tester.pumpAndSettle();

    expect(find.text('Ainda não confirmaste nenhuma subscrição.'), findsNothing);
    expect(find.textContaining('Ativa'), findsOneWidget);

    await disposeCleanly(tester);
  });

  testWidgets('ignoring a suggestion removes it from the list', (tester) async {
    await pumpSubscriptionsPage(tester);

    expect(find.text('Netflix'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Ignorar'));
    await tester.pumpAndSettle();

    expect(find.text('Netflix'), findsNothing);
    expect(find.text('Sem novas sugestões por agora.'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
