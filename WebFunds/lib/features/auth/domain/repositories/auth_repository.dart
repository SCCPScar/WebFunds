import '../../../../core/result/result.dart';
import '../entities/auth_user.dart';

/// Domain-layer contract for authentication. Implemented by
/// `AuthRepositoryImpl` in the Infrastructure layer.
abstract class AuthRepository {
  Future<Result<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  });
}