import '../../../../core/result/result.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Result<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  });
}
