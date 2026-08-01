import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/features/profile/presentation/pages/profile_page.dart';
import 'package:webfunds/theme/theme_mode_provider.dart';

void main() {
  Future<void> pumpProfilePage(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ProfilePage()),
      ),
    );
    // Drain the startup minimum-dwell timer (900ms, see app_smoke_test.dart)
    // triggered transitively by authGateControllerProvider's build(), which
    // listens to startupProvider. pumpAndSettle() alone stops as soon as no
    // more frames are scheduled, which can happen before that fixed timer
    // elapses, leaving it pending at test teardown.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
  }

  testWidgets('shows a fallback when no session is active', (tester) async {
    await pumpProfilePage(tester);

    expect(find.text('Sem sessão'), findsOneWidget);
  });

  testWidgets('switching Appearance updates themeModeProvider', (tester) async {
    late WidgetRef capturedRef;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const ProfilePage();
            },
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(capturedRef.read(themeModeProvider), ThemeMode.dark);

    await tester.tap(find.text('Claro'));
    await tester.pumpAndSettle();

    expect(capturedRef.read(themeModeProvider), ThemeMode.light);
  });

  testWidgets('tapping Terminar sessão shows a confirmation dialog', (tester) async {
    await pumpProfilePage(tester);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Terminar sessão'));
    await tester.pumpAndSettle();

    expect(find.text('Tens a certeza que queres terminar a sessão?'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Tens a certeza que queres terminar a sessão?'), findsNothing);
  });
}
