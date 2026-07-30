import '../../core/animation/motion_tokens.dart';
import '../startup_result.dart';
import '../startup_task.dart';

class MinimumDwellTask extends StartupTask {
  const MinimumDwellTask();

  @override
  String get name => 'MinimumDwell';

  @override
  Future<void> run(StartupResultBuilder builder) {
    return Future<void>.delayed(MotionDurations.splashMinimumDwell);
  }
}
