import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/auth/domain/repositories/biometric_preference_repository.dart';
import 'package:webfunds/features/auth/presentation/controllers/auth_providers.dart';
import 'package:webfunds/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:webfunds/features/onboarding/presentation/controllers/onboarding_providers.dart';
import 'package:webfunds/features/onboarding/presentation/pages/onboarding_page.dart';

class _FalseOnboardingComplete extends OnboardingCompleteNotifier {
  @override
  bool build() => false;
}

// Real `SecureStorageBiometricPreferenceRepository`/
// `SecureStorageOnboardingRepository` hit `flutter_secure_storage`'s
// platform channel, which hangs `pumpAndSettle` under `flutter_test`
// (same class of issue as the Drift `.first`-on-stream deadlock fixed in
// `DetectNotificationsUseCase` — some platform-channel I/O never settles
// here). Fake both repositories entirely, the same way Drift-backed
// tests fake `appDatabaseProvider` instead of touching real IO.
class _FakeBiometricPreferenceRepository implements BiometricPreferenceRepository {
  bool enabled = false;

  @override
  Future<Result<bool>> isBiometricEnabled() async => Success(enabled);

  @override
  Future<Result<void>> setBiometricEnabled(bool value) async {
    enabled = value;
    return const Success(null);
  }
}

class _FakeOnboardingRepository implements OnboardingRepository {
  bool complete = false;

  @override
  Future<Result<bool>> isComplete() async => Success(complete);

  @override
  Future<Result<void>> markComplete() async {
    complete = true;
    return const Success(null);
  }
}

void main() {
  Future<void> tapNext(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(ElevatedButton, 'Seguinte'));
    await tester.pumpAndSettle();
  }

  testWidgets('walking through every step ends on Abrir Central and completes onboarding',
      (tester) async {
    late WidgetRef capturedRef;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingCompleteProvider.overrideWith(() => _FalseOnboardingComplete()),
          biometricPreferenceRepositoryProvider.overrideWithValue(
            _FakeBiometricPreferenceRepository(),
          ),
          onboardingRepositoryProvider.overrideWithValue(_FakeOnboardingRepository()),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const OnboardingPage();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo ao WebFunds'), findsOneWidget);

    await tapNext(tester);
    expect(find.text('Como funciona'), findsOneWidget);

    await tapNext(tester);
    expect(find.text('Segurança'), findsOneWidget);

    await tapNext(tester);
    expect(find.text('Preferências'), findsOneWidget);

    await tapNext(tester);
    expect(find.text('Conhece o Weaver'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Abrir Central'), findsOneWidget);

    expect(capturedRef.read(onboardingCompleteProvider), isFalse);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Abrir Central'));
    await tester.pumpAndSettle();

    expect(capturedRef.read(onboardingCompleteProvider), isTrue);
  });
}
