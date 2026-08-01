import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../auth/presentation/controllers/auth_gate_controller.dart';
import '../../domain/entities/weaver_action.dart';
import '../../domain/entities/weaver_alert.dart';
import '../../domain/entities/weaver_insight.dart';
import '../controllers/weaver_analysis_providers.dart';
import '../utils/weaver_presentation.dart';

/// Weaver's home — "a financial copilot that interprets the owner's
/// data", not a chat. Every section here is backed by `WeaverEngine`'s
/// local analysis (see `weaver_analysis_providers.dart`); nothing calls
/// an LLM or a bank — those integrations stay behind the `AIRepository`/
/// `BankRepository` contracts until they're real. No Scaffold of its
/// own — this is a shell branch, `AppShell` already supplies one (see
/// `FinancesPage`'s reasoning).
class WeaverPage extends StatefulWidget {
  const WeaverPage({super.key});

  @override
  State<WeaverPage> createState() => _WeaverPageState();
}

class _WeaverPageState extends State<WeaverPage> {
  final _insightsKey = GlobalKey();

  void _scrollToInsights() {
    final context = _insightsKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 300));
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature ainda não está disponível.')),
    );
  }

  void _onActionTap(BuildContext context, WeaverActionType type) {
    switch (type) {
      case WeaverActionType.analyzeFinances:
        _scrollToInsights();
      case WeaverActionType.setGoal:
        context.push(AppRoutes.dreams);
      case WeaverActionType.reviewExpenses:
        context.go(AppRoutes.finances);
      case WeaverActionType.netWorth:
        context.push(AppRoutes.accounts);
      case WeaverActionType.upcomingBills:
        context.push(AppRoutes.subscriptions);
      case WeaverActionType.createBudget:
        _showComingSoon(context, 'Orçamentos');
      case WeaverActionType.monthlyPlanning:
        _showComingSoon(context, 'Planeamento mensal');
      case WeaverActionType.forecasts:
        _showComingSoon(context, 'Previsões');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const _WeaverGreeting(),
        const SizedBox(height: AppSpacing.lg),
        const _WeaverAlertsSection(),
        const _WeaverSummaryRow(),
        const SizedBox(height: AppSpacing.xl),
        Text('Ações rápidas', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _WeaverActionsGrid(onTap: (type) => _onActionTap(context, type)),
        const SizedBox(height: AppSpacing.xl),
        _WeaverInsightsSection(key: _insightsKey),
        const SizedBox(height: AppSpacing.xl),
        const _WeaverRecommendationsSection(),
        const SizedBox(height: AppSpacing.xl),
        const _WeaverConversationsTeaser(),
      ],
    );
  }
}

class _WeaverGreeting extends ConsumerWidget {
  const _WeaverGreeting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authGateControllerProvider);
    final email = switch (authState) {
      AuthGateAuthenticated(:final user) => user.email,
      AuthGateAwaitingBiometric(:final user) => user.email,
      _ => null,
    };
    final name = email?.split('@').first;

    return Text(
      name == null ? 'Olá!' : 'Olá, $name.',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class _WeaverSummaryRow extends ConsumerWidget {
  const _WeaverSummaryRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(weaverInsightsProvider);

    return insightsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (result) => result.fold(
        onSuccess: (insights) {
          if (insights.isEmpty) return const SizedBox.shrink();
          final netWorth = _findInsight(insights, WeaverInsightType.totalNetWorth);
          final accountCount = _findInsight(insights, WeaverInsightType.accountCount);

          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Row(
              children: [
                if (netWorth != null) Expanded(child: _SummaryStat(insight: netWorth)),
                if (netWorth != null && accountCount != null) const SizedBox(width: AppSpacing.sm),
                if (accountCount != null) Expanded(child: _SummaryStat(insight: accountCount)),
              ],
            ),
          );
        },
        onError: (failure) => const SizedBox.shrink(),
      ),
    );
  }
}

WeaverInsight? _findInsight(List<WeaverInsight> insights, WeaverInsightType type) {
  for (final insight in insights) {
    if (insight.type == type) return insight;
  }
  return null;
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.insight});

  final WeaverInsight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(insight.title, style: theme.textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(insight.description, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _WeaverActionsGrid extends StatelessWidget {
  const _WeaverActionsGrid({required this.onTap});

  final void Function(WeaverActionType type) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.2,
      children: [
        for (final action in WeaverAction.all)
          Card(
            child: InkWell(
              onTap: () => onTap(action.type),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(action.type.icon, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: AppSpacing.xs),
                    Text(action.title, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _WeaverAlertsSection extends ConsumerWidget {
  const _WeaverAlertsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(weaverAlertsProvider);

    return alertsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (result) => result.fold(
        onSuccess: (alerts) {
          if (alerts.isEmpty) return const SizedBox.shrink();
          return Column(
            children: [
              for (final alert in alerts) _WeaverAlertCard(alert: alert),
              const SizedBox(height: AppSpacing.sm),
            ],
          );
        },
        onError: (failure) => const SizedBox.shrink(),
      ),
    );
  }
}

class _WeaverAlertCard extends StatelessWidget {
  const _WeaverAlertCard({required this.alert});

  final WeaverAlert alert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.errorContainer,
      child: ListTile(
        leading: Icon(alert.severity.icon, color: theme.colorScheme.onErrorContainer),
        title: Text(alert.title, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
        subtitle: Text(
          alert.description,
          style: TextStyle(color: theme.colorScheme.onErrorContainer),
        ),
      ),
    );
  }
}

class _WeaverInsightsSection extends ConsumerWidget {
  const _WeaverInsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(weaverInsightsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Insights', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        insightsAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (error, stackTrace) => AppErrorView(
            failure: const UnknownFailure(),
            onRetry: () => ref.invalidate(weaverInsightsProvider),
          ),
          data: (result) => result.fold(
            onSuccess: (insights) {
              if (insights.isEmpty) {
                return const Text('Ainda não há dados suficientes para gerar insights.');
              }
              return Column(
                children: [for (final insight in insights) _WeaverInsightTile(insight: insight)],
              );
            },
            onError: (failure) => AppErrorView(
              failure: failure,
              onRetry: () => ref.invalidate(weaverInsightsProvider),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeaverInsightTile extends StatelessWidget {
  const _WeaverInsightTile({required this.insight});

  final WeaverInsight insight;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(insight.type.icon, color: Theme.of(context).colorScheme.primary),
        title: Text(insight.title),
        subtitle: Text(insight.description),
      ),
    );
  }
}

class _WeaverRecommendationsSection extends ConsumerWidget {
  const _WeaverRecommendationsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(weaverRecommendationsProvider);

    return recommendationsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (result) => result.fold(
        onSuccess: (recommendations) {
          if (recommendations.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sugestões automáticas', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final recommendation in recommendations)
                Card(
                  child: ListTile(
                    leading: Icon(
                      recommendation.type.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(recommendation.title),
                    subtitle: Text(recommendation.description),
                  ),
                ),
            ],
          );
        },
        onError: (failure) => const SizedBox.shrink(),
      ),
    );
  }
}

class _WeaverConversationsTeaser extends StatelessWidget {
  const _WeaverConversationsTeaser();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(AppIcons.weaver, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text('Conversas com o Weaver', style: theme.textTheme.titleMedium),
                const Spacer(),
                const Chip(label: Text('Em breve'), visualDensity: VisualDensity.compact),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Em breve vais poder perguntar ao Weaver sobre as tuas finanças diretamente.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            const TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Pergunta ao Weaver...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
