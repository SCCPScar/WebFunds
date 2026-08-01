import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/features/vault/presentation/pages/vault_page.dart';
import 'package:webfunds/services/database/app_database.dart';

void main() {
  Future<void> pumpVaultPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
        ],
        // `VaultPage` has no Scaffold of its own — it's a shell branch,
        // and `AppShell` supplies one in the real app.
        child: const MaterialApp(home: Scaffold(body: VaultPage())),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  }

  testWidgets('shows the empty state and creating a Dream through the FAB adds it',
      (tester) async {
    await pumpVaultPage(tester);

    expect(find.textContaining('Ainda não tens objetivos'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nome'), 'Casa de férias');
    await tester.enterText(find.widgetWithText(TextFormField, 'Valor alvo'), '5000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Criar objetivo'));
    await tester.pumpAndSettle();

    expect(find.text('Casa de férias'), findsOneWidget);
    expect(find.textContaining('Ainda não tens objetivos'), findsNothing);

    await disposeCleanly(tester);
  });
}
