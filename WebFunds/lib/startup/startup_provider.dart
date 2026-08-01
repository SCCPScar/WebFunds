import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/controllers/auth_providers.dart';
import '../services/logging/app_logger.dart';
import 'startup_coordinator.dart';
import 'startup_result.dart';
import 'startup_task.dart';
import 'tasks/minimum_dwell_task.dart';
import 'tasks/session_check_task.dart';

/// Wires up which [StartupTask]s run at boot. To add a new one: add it to
/// this list. Nothing else in `startup/` or `StartupCoordinator` changes.
///
/// Onboarding-complete is deliberately NOT a startup task here — it only
/// matters once a session is confirmed (an unauthenticated person always
/// goes to Login regardless), so `AuthGateController` checks it the same
/// way it already checks the biometric preference: after `sessionUser` is
/// known to be non-null, not unconditionally on every boot.
final startupTasksProvider = Provider<List<StartupTask>>((ref) {
  return [
    SessionCheckTask(ref.watch(checkSessionUseCaseProvider), ref.watch(appLoggerProvider)),
    const MinimumDwellTask(),
  ];
});

final startupCoordinatorProvider = Provider<StartupCoordinator>((ref) {
  return StartupCoordinator(ref.watch(startupTasksProvider), ref.watch(appLoggerProvider));
});

/// What `AuthGateController` watches. Knows nothing about tasks — only
/// that a [StartupCoordinator] exists and produces a [StartupResult].
final startupProvider = FutureProvider<StartupResult>((ref) {
  return ref.watch(startupCoordinatorProvider).run();
});
