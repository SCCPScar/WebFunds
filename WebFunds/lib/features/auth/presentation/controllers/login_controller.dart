import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../application/usecases/sign_in_with_email_usecase.dart';
import '../../domain/entities/auth_user.dart';
import 'auth_providers.dart';

/// State for the Login screen.
sealed class LoginState {
  const LoginState();
}

final class LoginIdle extends LoginState {
  const LoginIdle();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);
  final AuthUser user;
}

final class LoginFailed extends LoginState {
  const LoginFailed(this.failure);
  final Failure failure;
}

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginIdle();

  Future<void> signIn({required String email, required String password}) async {
    state = const LoginLoading();

    final useCase = ref.read(signInWithEmailUseCaseProvider);
    final result = await useCase(
      SignInWithEmailParams(email: email, password: password),
    );

    state = switch (result) {
      Success<AuthUser>(:final data) => LoginSuccess(data),
      ResultError<AuthUser>(:final failure) => LoginFailed(failure),
    };
  }

  void reset() => state = const LoginIdle();
}