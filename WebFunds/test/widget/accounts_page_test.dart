import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/features/accounts/presentation/pages/accounts_page.dart';
import 'package:webfunds/services/database/app_database.dart';

void main() {
  Future<void> pumpAccountsPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
        ],
        child: const MaterialApp(home: AccountsPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Drift's watch-query cancellation schedules a zero-duration Timer when
  // its last listener (the autoDispose StreamProvider) goes away. Letting
  // the framework unmount the tree at test teardown leaves that Timer
  // pending and fails the "no pending timers" check, so each test unmounts
  // explicitly first and pumps once more to let it fire.
  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  }

  testWidgets('shows the empty state before any Account exists', (tester) async {
    await pumpAccountsPage(tester);

    expect(find.textContaining('Ainda não tens contas'), findsOneWidget);

    await disposeCleanly(tester);
  });

  testWidgets('creating an Account through the form makes it appear in the list', (tester) async {
    await pumpAccountsPage(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nome'), 'Conta Corrente');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Criar conta'));
    await tester.pumpAndSettle();

    expect(find.text('Conta Corrente'), findsOneWidget);
    expect(find.textContaining('Ainda não tens contas'), findsNothing);

    await disposeCleanly(tester);
  });

  testWidgets('archiving an Account removes it from the list', (tester) async {
    await pumpAccountsPage(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Nome'), 'Conta a Arquivar');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Criar conta'));
    await tester.pumpAndSettle();

    expect(find.text('Conta a Arquivar'), findsOneWidget);

    await tester.tap(find.byTooltip('Arquivar conta'));
    await tester.pumpAndSettle();

    expect(find.text('Conta a Arquivar'), findsNothing);
    expect(find.textContaining('Ainda não tens contas'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
