import '../services/logging/app_logger.dart';
import 'startup_result.dart';
import 'startup_task.dart';

/// Runs every [StartupTask] in parallel and assembles their contributions
/// into one [StartupResult]. Holds no reference to Riverpod — it can be
/// unit tested with a plain list of fake tasks and a fake logger.
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
          // One task failing unexpectedly must never take the others (or
          // the whole app boot) down with it.
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
