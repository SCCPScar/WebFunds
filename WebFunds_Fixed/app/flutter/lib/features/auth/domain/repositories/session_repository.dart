import '../../../../core/result/result.dart';
import '../entities/auth_user.dart';

abstract class SessionRepository {
  Future<Result<AuthUser?>> getCurrentSession();
}
