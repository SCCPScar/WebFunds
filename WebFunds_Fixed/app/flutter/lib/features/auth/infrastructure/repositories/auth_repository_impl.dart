import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../services/supabase/supabase_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  Future<Result<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!_supabaseService.isInitialized) {
      return ResultError(
        mapExceptionToFailure(
          const ServerException(
            'O Supabase ainda não está configurado neste ambiente.',
            code: 'supabase_not_configured',
          ),
        ),
      );
    }

    try {
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return ResultError(
          mapExceptionToFailure(
            const AuthException('Não foi possível iniciar sessão.'),
          ),
        );
      }

      return Success(AuthUser(id: user.id, email: user.email ?? email));
    } on supabase.AuthException catch (e) {
      return ResultError(mapExceptionToFailure(AuthException(e.message, cause: e)));
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(UnknownException('Algo correu mal ao iniciar sessão.', cause: e)),
      );
    }
  }
}
