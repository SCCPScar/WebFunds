import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/app.dart';

void main() {
  testWidgets('WebFundsApp boots and shows the Splash screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: WebFundsApp()),
    );
    // A single pump is enough to verify the initial frame renders without
    // error, before startup resolves and the Route Guard navigates away.
    await tester.pump();

    expect(find.text('WebFunds'), findsOneWidget);

    // Drain the startup minimum-dwell timer (900ms) and the Splash
    // animations so no Timer is left pending when the test tears down the
    // widget tree. pumpAndSettle() alone isn't enough: it stops as soon as
    // no more frames are scheduled, which can happen before the fixed
    // 900ms dwell timer elapses. Where the app ends up after settling is
    // irrelevant here — it's covered by the next test.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
  });

  testWidgets('Splash navigates to Login once startup resolves (no Supabase configured)', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: WebFundsApp()),
    );
    await tester.pump();
    // Startup's minimum dwell (900ms) + session check resolve, then the
    // Route Guard reacts and redirects.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vinda de volta'), findsOneWidget);
  });
}