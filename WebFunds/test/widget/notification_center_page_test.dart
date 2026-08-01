import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/providers/shared_providers.dart';
import 'package:webfunds/design_system/icons/app_icons.dart';
import 'package:webfunds/features/notifications/presentation/pages/notification_center_page.dart';
import 'package:webfunds/services/database/app_database.dart';

void main() {
  late AppDatabase database;

  Future<void> pumpNotificationCenterPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: NotificationCenterPage()),
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

  testWidgets('shows the empty state before any notification exists', (tester) async {
    await pumpNotificationCenterPage(tester);

    expect(find.textContaining('Estás em dia'), findsOneWidget);

    await disposeCleanly(tester);
  });

  testWidgets('detects a Mystery notification and archiving it moves it to Arquivadas',
      (tester) async {
    await database.into(database.mysteries).insert(
          MysteryRow(
            id: 'mystery-1',
            transactionId: 'transaction-1',
            reason: 'unknownMerchant',
            status: 'open',
            createdAt: DateTime(2026, 1, 1),
            updatedAt: DateTime(2026, 1, 1),
          ),
        );

    await pumpNotificationCenterPage(tester);

    expect(find.text('Novo mistério detetado'), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.archive).hitTestable());
    await tester.pumpAndSettle();

    expect(find.text('Arquivadas'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
