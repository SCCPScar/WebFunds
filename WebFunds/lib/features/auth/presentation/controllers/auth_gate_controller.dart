import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/use_case.dart';
import '../../../../startup/startup_provider.dart';
import '../../../../startup/startup_result.dart';
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
    final biometricEnabled = preferenceResult.dataOrNull ?? false;

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

  /// Placeholder sign-out. Does not yet call a real Supabase sign-out —
  /// belongs to a future Profile/Settings feature.
  void signOut() => state = const AuthGateUnauthenticated();
}