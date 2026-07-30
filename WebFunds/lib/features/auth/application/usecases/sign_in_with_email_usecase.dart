import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class SignInWithEmailParams {
  const SignInWithEmailParams({required this.email, required this.password});

  final String email;
  final String password;
}

/// Orchestrates signing in — a thin pass-through to [AuthRepository]
/// today, but the seam where future Application-layer concerns get added
/// without touching Presentation.
class SignInWithEmailUseCase extends UseCase<AuthUser, SignInWithEmailParams> {
  const SignInWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AuthUser>> call(SignInWithEmailParams params) async {
    if (params.email.trim().isEmpty || params.password.isEmpty) {
      return const ResultError(
        ValidationFailure(message: 'Email e palavra-passe são obrigatórios.'),
      );
    }

    return _repository.signInWithEmail(
      email: params.email.trim(),
      password: params.password,
    );
  }
}