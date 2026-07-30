import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/session_repository.dart';

class CheckSessionUseCase extends UseCase<AuthUser?, NoParams> {
  const CheckSessionUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Result<AuthUser?>> call(NoParams params) {
    return _repository.getCurrentSession();
  }
}
