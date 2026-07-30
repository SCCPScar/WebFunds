import '../../../../core/result/result.dart';
import '../entities/auth_user.dart';

/// Domain-layer contract for checking whether an owner session already
/// exists — the seam `AuthGateController` uses to decide between the
/// Face ID screen and the Login screen.
abstract class SessionRepository {
  /// Returns the currently active [AuthUser] if a session exists, or
  /// `null` (wrapped in a [Success]) if it does not. A [ResultError]
  /// means the check itself failed — the caller should treat that the
  /// same as "no session" and fail safe to Login.
  Future<Result<AuthUser?>> getCurrentSession();
}