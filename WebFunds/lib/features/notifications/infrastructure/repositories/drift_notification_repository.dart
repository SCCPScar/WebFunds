import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/notification_dao.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_category.dart';
import '../../domain/entities/notification_priority.dart';
import '../../domain/entities/notification_state.dart';
import '../../domain/repositories/notification_repository.dart';
import '../mappers/notification_mapper.dart';

/// Real, Drift-backed implementation of [NotificationRepository],
/// following the same shape every other Repository in WebFunds does.
class DriftNotificationRepository implements NotificationRepository {
  const DriftNotificationRepository(this._dao, this._idGenerator, this._clock);

  final NotificationDao _dao;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Stream<Result<List<AppNotification>>> watchAll() {
    return _dao.watchAll().transform(
          StreamTransformer<List<NotificationRow>, Result<List<AppNotification>>>.fromHandlers(
            handleData: (rows, sink) {
              sink.add(Success(rows.map(NotificationMapper.toDomain).toList()));
            },
            handleError: (error, stackTrace, sink) {
              sink.add(
                ResultError(
                  mapExceptionToFailure(
                    CacheException('Não foi possível observar as notificações.', cause: error),
                  ),
                ),
              );
            },
          ),
        );
  }

  @override
  Stream<Result<int>> watchUnreadCount() {
    return watchAll().map((result) {
      return result.fold(
        onSuccess: (notifications) {
          final unread = notifications.where((n) => n.state == NotificationState.unread).length;
          return Success(unread);
        },
        onError: ResultError<int>.new,
      );
    });
  }

  @override
  Future<Result<AppNotification?>> createIfAbsent({
    required String title,
    required String description,
    required NotificationCategory category,
    required NotificationPriority priority,
    required String sourceKey,
    String? relatedEntityId,
  }) async {
    try {
      final existing = await _dao.findBySourceKey(sourceKey);
      if (existing != null) return const Success(null);

      final notification = AppNotification(
        id: _idGenerator.generate(),
        title: title,
        description: description,
        category: category,
        priority: priority,
        state: NotificationState.unread,
        sourceKey: sourceKey,
        relatedEntityId: relatedEntityId,
        createdAt: _clock.now(),
      );
      await _dao.insertRow(NotificationMapper.toRow(notification));
      return Success(notification);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível criar a notificação.', cause: e)),
      );
    }
  }

  @override
  Future<Result<AppNotification>> updateState(String id, NotificationState state) async {
    try {
      final row = await _dao.findById(id);
      if (row == null) {
        return const ResultError(ValidationFailure(message: 'Esta notificação já não existe.'));
      }
      final updated = NotificationMapper.toDomain(row);
      final withNewState = AppNotification(
        id: updated.id,
        title: updated.title,
        description: updated.description,
        category: updated.category,
        priority: updated.priority,
        state: state,
        sourceKey: updated.sourceKey,
        relatedEntityId: updated.relatedEntityId,
        createdAt: updated.createdAt,
      );
      await _dao.updateRow(NotificationMapper.toRow(withNewState));
      return Success(withNewState);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(
          CacheException('Não foi possível atualizar a notificação.', cause: e),
        ),
      );
    }
  }
}
