import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/notification_dao.dart';
import '../../../dreams/presentation/controllers/dream_providers.dart';
import '../../../mysteries/presentation/controllers/mystery_providers.dart';
import '../../application/usecases/detect_notifications_usecase.dart';
import '../../application/usecases/update_notification_state_usecase.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../infrastructure/repositories/drift_notification_repository.dart';

final notificationDaoProvider = Provider<NotificationDao>((ref) {
  return ref.watch(appDatabaseProvider).notificationDao;
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return DriftNotificationRepository(
    ref.watch(notificationDaoProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  );
});

final detectNotificationsUseCaseProvider = Provider<DetectNotificationsUseCase>((ref) {
  return DetectNotificationsUseCase(
    ref.watch(dreamRepositoryProvider),
    ref.watch(mysteryRepositoryProvider),
    ref.watch(notificationRepositoryProvider),
    ref.watch(clockProvider),
  );
});

final updateNotificationStateUseCaseProvider = Provider<UpdateNotificationStateUseCase>((ref) {
  return UpdateNotificationStateUseCase(ref.watch(notificationRepositoryProvider));
});

final notificationsStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(notificationRepositoryProvider).watchAll();
});

final unreadNotificationCountProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(notificationRepositoryProvider).watchUnreadCount();
});

/// Runs detection once per page mount — same one-shot-on-mount shape as
/// `mysteryDetectionProvider`.
final notificationDetectionProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(detectNotificationsUseCaseProvider).call();
});
