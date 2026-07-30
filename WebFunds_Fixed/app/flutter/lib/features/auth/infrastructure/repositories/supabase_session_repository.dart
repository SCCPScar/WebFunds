import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../services/supabase/supabase_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/session_repository.dart';

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
}
