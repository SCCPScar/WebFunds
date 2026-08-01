import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../dreams/domain/entities/dream.dart';
import '../../../dreams/domain/entities/dream_status.dart';
import '../../../dreams/domain/repositories/dream_repository.dart';
import '../../../mysteries/domain/entities/mystery.dart';
import '../../../mysteries/domain/entities/mystery_status.dart';
import '../../../mysteries/domain/repositories/mystery_repository.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_category.dart';
import '../../domain/entities/notification_priority.dart';
import '../../domain/repositories/notification_repository.dart';

/// Scans Dreams and Mysteries for the rule-detectable events from
/// `docs/01-Experience/08-Notifications.md`'s own examples — "Dream
/// completed", "You reached 50% of your Travel Dream", "A new unknown
/// merchant was detected", "A Mystery has been unresolved for seven
/// days" — and persists a Notification for each newly-found one.
/// Idempotent: `NotificationRepository.createIfAbsent` skips anything
/// whose `sourceKey` already exists, so running this repeatedly (every
/// time the Notification Center opens) never duplicates.
class DetectNotificationsUseCase {
  const DetectNotificationsUseCase(
    this._dreamRepository,
    this._mysteryRepository,
    this._notificationRepository,
    this._clock,
  );

  static const _staleMysteryThreshold = Duration(days: 7);

  final DreamRepository _dreamRepository;
  final MysteryRepository _mysteryRepository;
  final NotificationRepository _notificationRepository;
  final Clock _clock;

  Future<Result<List<AppNotification>>> call() async {
    final created = <AppNotification>[];

    final dreamsResult = await _dreamRepository.watchActive().first;
    for (final dream in dreamsResult.dataOrNull ?? const <Dream>[]) {
      created.addAll(await _detectForDream(dream));
    }

    final mysteriesResult = await _mysteryRepository.getAll();
    for (final mystery in mysteriesResult.dataOrNull ?? const <Mystery>[]) {
      created.addAll(await _detectForMystery(mystery));
    }

    return Success(created);
  }

  Future<List<AppNotification>> _detectForDream(Dream dream) async {
    final created = <AppNotification>[];

    if (dream.status == DreamStatus.completed) {
      final result = await _notificationRepository.createIfAbsent(
        title: 'Objetivo concluído!',
        description: '"${dream.name}" atingiu o valor pretendido.',
        category: NotificationCategory.dream,
        priority: NotificationPriority.high,
        sourceKey: 'dream:completed:${dream.id}',
        relatedEntityId: dream.id,
      );
      if (result case Success(data: final notification?)) created.add(notification);
    } else if (dream.status == DreamStatus.active && dream.progress >= 0.5) {
      final result = await _notificationRepository.createIfAbsent(
        title: 'A meio caminho',
        description: 'Atingiste metade do objetivo "${dream.name}".',
        category: NotificationCategory.dream,
        priority: NotificationPriority.normal,
        sourceKey: 'dream:milestone50:${dream.id}',
        relatedEntityId: dream.id,
      );
      if (result case Success(data: final notification?)) created.add(notification);
    }

    return created;
  }

  Future<List<AppNotification>> _detectForMystery(Mystery mystery) async {
    if (mystery.status != MysteryStatus.open) return const [];

    final created = <AppNotification>[];

    final detectedResult = await _notificationRepository.createIfAbsent(
      title: 'Novo mistério detetado',
      description: 'Uma transação precisa de mais contexto.',
      category: NotificationCategory.mystery,
      priority: NotificationPriority.normal,
      sourceKey: 'mystery:detected:${mystery.id}',
      relatedEntityId: mystery.transactionId,
    );
    if (detectedResult case Success(data: final notification?)) created.add(notification);

    if (_clock.now().difference(mystery.createdAt) >= _staleMysteryThreshold) {
      final staleResult = await _notificationRepository.createIfAbsent(
        title: 'Mistério por resolver há 7 dias',
        description: 'Uma transação continua à espera de ser esclarecida.',
        category: NotificationCategory.mystery,
        priority: NotificationPriority.high,
        sourceKey: 'mystery:stale:${mystery.id}',
        relatedEntityId: mystery.transactionId,
      );
      if (staleResult case Success(data: final notification?)) created.add(notification);
    }

    return created;
  }
}
