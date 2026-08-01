import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/use_case.dart';
import '../../../../startup/startup_provider.dart';
import '../../../../startup/startup_result.dart';
import '../../../onboarding/presentation/controllers/onboarding_providers.dart';
import '../../domain/entities/auth_user.dart';
import 'auth_providers.dart';

/// Everything the app's Route Guard needs to know to decide what the
/// person is allowed to see right now.
sealed class AuthGateState {
  const AuthGateState();
}

/// Startup is still resolving — only Splash may be shown.
final class AuthGateUnknown extends AuthGateState {
  const AuthGateUnknown();
}

final class AuthGateUnauthenticated extends AuthGateState {
  const AuthGateUnauthenticated();
}

/// A session exists, but the person opted into Face ID and hasn't
/// confirmed it yet this launch.
final class AuthGateAwaitingBiometric extends AuthGateState {
  const AuthGateAwaitingBiometric(this.user);
  final AuthUser user;
}

final class AuthGateAuthenticated extends AuthGateState {
  const AuthGateAuthenticated(this.user);
  final AuthUser user;
}

final authGateControllerProvider = NotifierProvider<AuthGateController, AuthGateState>(
  AuthGateController.new,
);

class AuthGateController extends Notifier<AuthGateState> {
  @override
  AuthGateState build() {
    ref.listen<AsyncValue<StartupResult>>(startupProvider, (previous, next) {
      next.whenData(_handleStartupResult);
    });
    return const AuthGateUnknown();
  }

  Future<void> _handleStartupResult(StartupResult result) async {
    final user = result.sessionUser;
    if (user == null) {
      state = const AuthGateUnauthenticated();
      return;
    }

    final getBiometricPreference = ref.read(getBiometricPreferenceUseCaseProvider);
    final preferenceResult = await getBiometricPreference(const NoParams());
    // Fail-safe: if the preference can't be read, never assume biometric
    // lock is off. Only an explicit `false` skips the Face ID gate.
    final biometricEnabled = preferenceResult.fold(
      onSuccess: (enabled) => enabled,
      onError: (_) => true,
    );

    final onboardingResult =
        await ref.read(getOnboardingCompleteUseCaseProvider).call(const NoParams());
    // Fail-safe the other direction: a storage error should never trap an
    // existing owner inside Onboarding again.
    final onboardingComplete = onboardingResult.fold(
      onSuccess: (complete) => complete,
      onError: (_) => true,
    );
    ref.read(onboardingCompleteProvider.notifier).set(onboardingComplete);

    state = biometricEnabled ? AuthGateAwaitingBiometric(user) : AuthGateAuthenticated(user);
  }

  /// Called by `LoginPage` after `SignInWithEmailUseCase` succeeds.
  void markAuthenticated(AuthUser user) => state = AuthGateAuthenticated(user);

  /// Called by `FaceIdPage` after a successful biometric prompt.
  void markUnlocked() {
    final current = state;
    if (current is AuthGateAwaitingBiometric) {
      state = AuthGateAuthenticated(current.user);
    }
  }

  /// Called by `FaceIdPage`'s "Entrar com palavra-passe" fallback.
  void requestPasswordFallback() => state = const AuthGateUnauthenticated();

  /// Ends the remote Supabase session before applying the local
  /// "signed out" state — otherwise the session would persist server-side
  /// and be silently resumed on the next app launch.
  Future<void> signOut() async {
    await ref.read(signOutUseCaseProvider).call(const NoParams());
    state = const AuthGateUnauthenticated();
  }
}
