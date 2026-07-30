import '../../core/usecase/use_case.dart';
import '../../features/auth/application/usecases/check_session_usecase.dart';
import '../../services/logging/app_logger.dart';
import '../startup_result.dart';
import '../startup_task.dart';

class SessionCheckTask extends StartupTask {
  const SessionCheckTask(this._checkSession, this._logger);

  final CheckSessionUseCase _checkSession;
  final AppLogger _logger;

  @override
  String get name => 'SessionCheck';

  @override
  Future<void> run(StartupResultBuilder builder) async {
    final result = await _checkSession(const NoParams());
    result.fold(
      onSuccess: (user) => builder.sessionUser = user,
      onError: (failure) {
        _logger.warning(
          'Session check failed, failing safe to no-session: ${failure.message}',
          tag: 'Startup',
        );
        builder.sessionUser = null;
      },
    );
  }
}