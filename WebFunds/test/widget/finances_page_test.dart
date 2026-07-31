import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/features/finances/presentation/pages/finances_page.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/services/database/tables/accounts_table.dart';

void main() {
  late AppDatabase database;

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: FinancesPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Same Drift watch-query teardown timer as accounts_page_test.dart /
  // current_cycle_section_test.dart.
  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  }

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.into(database.accounts).insert(
          AccountRow(
            id: 'account-1',
            name: 'Conta Teste',
            type: 'checking',
            openingBalanceMinorUnits: 0,
            openingBalanceCurrency: '€',
            createdAt: DateTime(2026, 1, 1),
            isArchived: false,
          ),
        );
  });

  tearDown(() => database.close());

  testWidgets('prompts to start a cycle when none is active', (tester) async {
    await pumpPage(tester);

    expect(
      find.text('Precisas de um ciclo financeiro ativo para veres e adicionares transações.'),
      findsOneWidget,
    );

    await disposeCleanly(tester);
  });

  testWidgets('starting a cycle then adding a transaction shows it in the list', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar ciclo').first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar ciclo').last);
    await tester.pumpAndSettle();

    expect(find.text('Ainda não há transações neste ciclo.'), findsOneWidget);

    await tester.tap(find.byTooltip('Adicionar transação'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Valor'), '50');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Merchant (opcional)'),
      'Continente',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Adicionar transação'));
    await tester.pumpAndSettle();

    expect(find.text('Continente'), findsOneWidget);
    expect(find.text('Ainda não há transações neste ciclo.'), findsNothing);

    await disposeCleanly(tester);
  });
}
