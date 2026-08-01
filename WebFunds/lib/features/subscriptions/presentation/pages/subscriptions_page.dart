import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../services/logging/app_logger.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../application/usecases/confirm_subscription_usecase.dart';
import '../../application/usecases/update_subscription_status_usecase.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_status.dart';
import '../../domain/entities/subscription_suggestion.dart';
import '../controllers/subscription_providers.dart';
import '../utils/subscription_frequency_presentation.dart';
import '../utils/subscription_status_presentation.dart';

/// Lists confirmed Subscriptions and rule-based suggestions detected
/// from Transaction history — `docs/02-Domain/08-Subscriptions.md`.
/// Suggestions are never persisted; only confirming one creates a real
/// Subscription.
class SubscriptionsPage extends ConsumerStatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  ConsumerState<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends ConsumerState<SubscriptionsPage> {
  final _dismissedMerchants = <String>{};

  Future<void> _confirm(SubscriptionSuggestion suggestion) async {
    final result = await ref
        .read(confirmSubscriptionUseCaseProvider)
        .call(ConfirmSubscriptionParams(suggestion: suggestion));
    if (!mounted) return;
    result.fold(
      onSuccess: (_) {
        ref.invalidate(subscriptionSuggestionsProvider);
      },
      onError: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  Future<void> _updateStatus(String id, SubscriptionStatus status) async {
    final result = await ref
        .read(updateSubscriptionStatusUseCaseProvider)
        .call(UpdateSubscriptionStatusParams(id: id, status: status));
    if (!mounted) return;
    result.fold(
      onSuccess: (_) {},
      onError: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestionsAsync = ref.watch(subscriptionSuggestionsProvider);
    final subscriptionsAsync = ref.watch(subscriptionsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Subscrições')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(subscriptionSuggestionsProvider),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text('Sugestões', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            suggestionsAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (error, stackTrace) {
                ref.read(appLoggerProvider).error(
                  'Falha inesperada ao detetar subscrições.',
                  tag: 'SubscriptionsPage',
                  error: error,
                  stackTrace: stackTrace,
                );
                return const AppErrorView(failure: UnknownFailure());
              },
              data: (result) => result.fold(
                onSuccess: (suggestions) {
                  final visible =
                      suggestions.where((s) => !_dismissedMerchants.contains(s.merchant)).toList();
                  if (visible.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Text('Sem novas sugestões por agora.'),
                    );
                  }
                  return Column(
                    children: [
                      for (final suggestion in visible)
                        _SuggestionCard(
                          suggestion: suggestion,
                          onConfirm: () => _confirm(suggestion),
                          onDismiss: () =>
                              setState(() => _dismissedMerchants.add(suggestion.merchant)),
                        ),
                    ],
                  );
                },
                onError: (failure) => AppErrorView(failure: failure),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('As tuas subscrições', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            subscriptionsAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (error, stackTrace) {
                ref.read(appLoggerProvider).error(
                  'Falha inesperada ao carregar as subscrições.',
                  tag: 'SubscriptionsPage',
                  error: error,
                  stackTrace: stackTrace,
                );
                return const AppErrorView(failure: UnknownFailure());
              },
              data: (result) => result.fold(
                onSuccess: (subscriptions) {
                  if (subscriptions.isEmpty) {
                    return const AppEmptyState(
                      icon: AppIcons.subscriptions,
                      message: 'Ainda não confirmaste nenhuma subscrição.',
                    );
                  }
                  return Column(
                    children: [
                      for (final subscription in subscriptions)
                        _SubscriptionTile(
                          subscription: subscription,
                          onStatusChange: (status) => _updateStatus(subscription.id, status),
                        ),
                    ],
                  );
                },
                onError: (failure) => AppErrorView(failure: failure),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.onConfirm,
    required this.onDismiss,
  });

  final SubscriptionSuggestion suggestion;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(AppIcons.subscriptions, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(suggestion.merchant, style: theme.textTheme.titleMedium)),
                Text(suggestion.averageAmount.format(), style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${suggestion.frequency.label} · ${suggestion.occurrenceCount} pagamentos · '
              'confiança ${suggestion.confidenceScore}%',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onDismiss, child: const Text('Ignorar')),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(onPressed: onConfirm, child: const Text('Confirmar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  const _SubscriptionTile({required this.subscription, required this.onStatusChange});

  final Subscription subscription;
  final void Function(SubscriptionStatus status) onStatusChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(AppIcons.subscriptions, color: theme.colorScheme.primary),
        title: Text(subscription.merchant),
        subtitle: Text(
          [
            subscription.frequency.label,
            subscription.status.label,
            if (subscription.nextExpectedDate != null)
              'Próxima: ${DateFormat('dd/MM/yyyy').format(subscription.nextExpectedDate!)}',
          ].join(' · '),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(subscription.expectedAmount.format()),
            PopupMenuButton<SubscriptionStatus>(
              onSelected: onStatusChange,
              itemBuilder: (context) => [
                if (subscription.status != SubscriptionStatus.active)
                  const PopupMenuItem(
                    value: SubscriptionStatus.active,
                    child: Text('Reativar'),
                  ),
                if (subscription.status == SubscriptionStatus.active)
                  const PopupMenuItem(
                    value: SubscriptionStatus.paused,
                    child: Text('Pausar'),
                  ),
                if (subscription.status != SubscriptionStatus.cancelled)
                  const PopupMenuItem(
                    value: SubscriptionStatus.cancelled,
                    child: Text('Cancelar'),
                  ),
                if (subscription.status != SubscriptionStatus.archived)
                  const PopupMenuItem(
                    value: SubscriptionStatus.archived,
                    child: Text('Arquivar'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
