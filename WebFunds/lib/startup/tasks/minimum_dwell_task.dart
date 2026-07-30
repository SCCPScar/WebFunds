import '../../core/animation/motion_tokens.dart';
import '../startup_result.dart';
import '../startup_task.dart';

/// Contributes nothing to [StartupResult] — exists purely so the brand
/// moment on Splash never flashes by instantly. Runs in parallel with the
/// real tasks via [StartupCoordinator]'s `Future.wait()`, so it only ever
/// adds *waiting time*, never blocks a task from starting.
class MinimumDwellTask extends StartupTask {
  const MinimumDwellTask();

  @override
  String get name => 'MinimumDwell';

  @override
  Future<void> run(StartupResultBuilder builder) {
    return Future<void>.delayed(MotionDurations.splashMinimumDwell);
  }
}