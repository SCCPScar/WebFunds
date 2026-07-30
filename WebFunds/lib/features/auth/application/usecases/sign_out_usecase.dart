import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/session_repository.dart';

/// Orchestrates signing out — a thin pass-through to [SessionRepository]
/// today, and the seam for future Application-layer concerns without
/// touching Presentation.
class SignOutUseCase extends UseCase<void, NoParams> {
  const SignOutUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.signOut();
  }
}
