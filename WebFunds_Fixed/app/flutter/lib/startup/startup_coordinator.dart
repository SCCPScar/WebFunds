import '../services/logging/app_logger.dart';
import 'startup_result.dart';
import 'startup_task.dart';

class StartupCoordinator {
  const StartupCoordinator(this._tasks, this._logger);

  final List<StartupTask> _tasks;
  final AppLogger _logger;

  Future<StartupResult> run() async {
    final builder = StartupResultBuilder();

    await Future.wait(
      _tasks.map((task) async {
        try {
          await task.run(builder);
        } catch (error, stackTrace) {
          _logger.error(
            'Startup task "${task.name}" failed unexpectedly',
            tag: 'Startup',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }),
    );

    return builder.build();
  }
}
