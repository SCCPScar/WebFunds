import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../application/usecases/update_notification_state_usecase.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_state.dart';
import '../controllers/notification_providers.dart';
import '../utils/notification_presentation.dart';

/// The Notification Center — `docs/01-Experience/08-Notifications.md`.
/// Detection runs once on mount (via `notificationDetectionProvider`);
/// the list itself comes from `notificationsStreamProvider`, which picks
/// up whatever detection just persisted automatically. Standalone route
/// like Dreams/Subscriptions/Profile, reachable from the bell icon in
/// `AppShell`'s AppBar.
class NotificationCenterPage extends ConsumerWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationDetectionProvider);
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: notificationsAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, stackTrace) => AppErrorView(
          failure: const UnknownFailure(),
          onRetry: () => ref.invalidate(notificationsStreamProvider),
        ),
        data: (result) => result.fold(
          onSuccess: (notifications) {
            final active = notifications
                .where(
                  (n) => n.state == NotificationState.unread || n.state == NotificationState.read,
                )
                .toList();
            final archived =
                notifications.where((n) => n.state == NotificationState.archived).toList();

            if (active.isEmpty && archived.isEmpty) {
              return const AppEmptyState(
                icon: AppIcons.notifications,
                message: 'Estás em dia. Nenhuma notificação precisa da tua atenção.',
              );
            }

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                if (active.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Text('Sem notificações por ler.'),
                  )
                else
                  for (final notification in active) _NotificationCard(notification: notification),
                if (archived.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text('Arquivadas', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  for (final notification in archived)
                    _ArchivedNotificationTile(notification: notification),
                ],
              ],
            );
          },
          onError: (failure) => AppErrorView(
            failure: failure,
            onRetry: () => ref.invalidate(notificationsStreamProvider),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.notification});

  final AppNotification notification;

  Future<void> _updateState(WidgetRef ref, NotificationState state) {
    return ref
        .read(updateNotificationStateUseCaseProvider)
        .call(UpdateNotificationStateParams(id: notification.id, state: state));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isUnread = notification.state == NotificationState.unread;

    return Card(
      color: isUnread ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
      child: ListTile(
        leading: Icon(notification.category.icon, color: theme.colorScheme.primary),
        title: Text(
          notification.title,
          style: isUnread
              ? theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)
              : theme.textTheme.titleSmall,
        ),
        subtitle: Text(notification.description),
        onTap: isUnread ? () => _updateState(ref, NotificationState.read) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(AppIcons.archive),
              tooltip: 'Arquivar',
              onPressed: () => _updateState(ref, NotificationState.archived),
            ),
            IconButton(
              icon: const Icon(AppIcons.dismiss),
              tooltip: 'Dispensar',
              onPressed: () => _updateState(ref, NotificationState.dismissed),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchivedNotificationTile extends StatelessWidget {
  const _ArchivedNotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(notification.category.icon),
      title: Text(notification.title),
      subtitle: Text(notification.description),
    );
  }
}
