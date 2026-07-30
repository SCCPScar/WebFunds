import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/app.dart';

void main() {
  testWidgets('WebFundsApp boots and shows the Splash screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: WebFundsApp()),
    );
    // Deliberately not pumpAndSettle(): startup resolves asynchronously
    // and the Route Guard navigates away from Splash once it does, so
    // settling fully could land elsewhere. A single pump is enough to
    // verify the initial frame renders without error.
    await tester.pump();

    expect(find.text('WebFunds'), findsOneWidget);
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