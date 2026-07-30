import 'startup_result.dart';

abstract class StartupTask {
  const StartupTask();

  String get name;

  Future<void> run(StartupResultBuilder builder);
}
