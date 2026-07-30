import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../services/supabase/supabase_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/session_repository.dart';

/// Real [SessionRepository], backed by `SupabaseService`. Safe by
/// construction when Supabase isn't configured yet: it never calls
/// `Supabase.instance` unless `SupabaseService.isInitialized` is true, so
/// "not configured" reads as "no session", never a thrown exception.
class SupabaseSessionRepository implements SessionRepository {
  const SupabaseSessionRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  Future<Result<AuthUser?>> getCurrentSession() async {
    if (!_supabaseService.isInitialized) {
      return const Success(null);
    }

    try {
      final user = _supabaseService.client.auth.currentSession?.user;
      if (user == null) return const Success(null);
      return Success(AuthUser(id: user.id, email: user.email ?? ''));
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(
          UnknownException('Não foi possível verificar a sessão.', cause: e),
        ),
      );
    }
  }

  @override
  Future<Result<void>> signOut() async {
    if (!_supabaseService.isInitialized) {
      return const Success(null);
    }

    try {
      await _supabaseService.client.auth.signOut();
      return const Success(null);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(
          UnknownException('Não foi possível terminar a sessão.', cause: e),
        ),
      );
    }
  }
}