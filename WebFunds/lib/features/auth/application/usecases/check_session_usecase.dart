import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/session_repository.dart';

/// Orchestrates the session check — a thin pass-through today, and the
/// seam for future Application-layer concerns (e.g. refreshing a token
/// close to expiring) without touching Presentation.
class CheckSessionUseCase extends UseCase<AuthUser?, NoParams> {
  const CheckSessionUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Result<AuthUser?>> call(NoParams params) {
    return _repository.getCurrentSession();
  }
}