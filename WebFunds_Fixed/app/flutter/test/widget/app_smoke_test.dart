import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/app.dart';

void main() {
  testWidgets('WebFundsApp boots and shows the Splash screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: WebFundsApp()),
    );
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
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vinda de volta'), findsOneWidget);
  });
}
