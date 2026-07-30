import 'startup_result.dart';

/// Contract every startup task implements — Session Check, and later
/// Remote Config, Local Database Migration, Analytics, Feature Flags,
/// Notification Initialization, etc.
///
/// A task never returns its own typed result directly; it writes into
/// the shared [StartupResultBuilder]. This is what lets
/// [StartupCoordinator] run a heterogeneous list of tasks through one
/// `Future.wait()` without needing a matching `switch` for every type.
abstract class StartupTask {
  const StartupTask();

  /// Used only for logging when a task fails unexpectedly.
  String get name;

  Future<void> run(StartupResultBuilder builder);
}