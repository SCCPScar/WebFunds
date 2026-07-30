import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/use_case.dart';
import '../../../../startup/startup_provider.dart';
import '../../../../startup/startup_result.dart';
import '../../domain/entities/auth_user.dart';
import 'auth_providers.dart';

sealed class AuthGateState {
  const AuthGateState();
}

final class AuthGateUnknown extends AuthGateState {
  const AuthGateUnknown();
}

final class AuthGateUnauthenticated extends AuthGateState {
  const AuthGateUnauthenticated();
}

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

  void markAuthenticated(AuthUser user) => state = AuthGateAuthenticated(user);

  void markUnlocked() {
    final current = state;
    if (current is AuthGateAwaitingBiometric) {
      state = AuthGateAuthenticated(current.user);
    }
  }

  void requestPasswordFallback() => state = const AuthGateUnauthenticated();

  void signOut() => state = const AuthGateUnauthenticated();
}
