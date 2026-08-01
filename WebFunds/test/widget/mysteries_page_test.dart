import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/features/mysteries/presentation/pages/mysteries_page.dart';
import 'package:webfunds/services/database/app_database.dart';

void main() {
  late AppDatabase database;

  Future<void> pumpMysteriesPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: MysteriesPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  }

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.into(database.transactions).insert(
          TransactionRow(
            id: 'transaction-1',
            financialCycleId: 'cycle-1',
            accountId: 'account-1',
            type: 'expense',
            amountMinorUnits: 2000,
            amountCurrency: '€',
            transactionDate: DateTime(2026, 1, 5),
            createdAt: DateTime(2026, 1, 5),
            updatedAt: DateTime(2026, 1, 5),
          ),
        );
  });

  tearDown(() => database.close());

  testWidgets('detects an unknown-merchant Mystery and resolving it moves it to Resolvidos',
      (tester) async {
    await pumpMysteriesPage(tester);

    expect(find.text('Merchant desconhecido'), findsWidgets);
    expect(find.text('1 mistério ativo'), findsOneWidget);

    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Merchant'), 'Continente');
    await tester.enterText(find.widgetWithText(TextFormField, 'Categoria'), 'Groceries');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Resolver'));
    await tester.pumpAndSettle();

    expect(find.text('Sem mistérios por resolver.'), findsOneWidget);
    expect(find.text('Resolvidos'), findsOneWidget);
    expect(find.text('Continente'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
