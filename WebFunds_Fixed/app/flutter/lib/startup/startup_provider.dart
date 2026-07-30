import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/controllers/auth_providers.dart';
import '../services/logging/app_logger.dart';
import 'startup_coordinator.dart';
import 'startup_result.dart';
import 'startup_task.dart';
import 'tasks/minimum_dwell_task.dart';
import 'tasks/session_check_task.dart';

final startupTasksProvider = Provider<List<StartupTask>>((ref) {
  return [
    SessionCheckTask(ref.watch(checkSessionUseCaseProvider), ref.watch(appLoggerProvider)),
    const MinimumDwellTask(),
  ];
});

final startupCoordinatorProvider = Provider<StartupCoordinator>((ref) {
  return StartupCoordinator(ref.watch(startupTasksProvider), ref.watch(appLoggerProvider));
});

final startupProvider = FutureProvider<StartupResult>((ref) {
  return ref.watch(startupCoordinatorProvider).run();
});
