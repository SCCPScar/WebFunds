import '../../../../core/result/result.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_state.dart';
import '../../domain/repositories/notification_repository.dart';

class UpdateNotificationStateParams {
  const UpdateNotificationStateParams({required this.id, required this.state});

  final String id;
  final NotificationState state;
}

/// Backs every Notification Action that changes state — Mark as Read,
/// Archive, Dismiss.
class UpdateNotificationStateUseCase {
  const UpdateNotificationStateUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<AppNotification>> call(UpdateNotificationStateParams params) {
    return _repository.updateState(params.id, params.state);
  }
}
