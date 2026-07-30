import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../controllers/dashboard_providers.dart';
import '../widgets/accounts_section.dart';
import '../widgets/goals_section.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/summary_section.dart';

class CentralPage extends ConsumerWidget {
  const CentralPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return summaryAsync.when(
      loading: () => const AppLoadingIndicator(message: 'A carregar o teu resumo...'),
      error: (error, stackTrace) => AppErrorView(
        failure: const UnknownFailure(),
        onRetry: () => ref.invalidate(dashboardSummaryProvider),
      ),
      data: (result) => result.fold(
        onSuccess: (summary) => _CentralSections(summary: summary),
        onError: (failure) => AppErrorView(
          failure: failure,
          onRetry: () => ref.invalidate(dashboardSummaryProvider),
        ),
      ),
    );
  }
}

class _CentralSections extends StatelessWidget {
  const _CentralSections({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        SummarySection(totalBalance: summary.totalBalance),
        const SizedBox(height: AppSpacing.lg),
        const AccountsSection(),
        const SizedBox(height: AppSpacing.lg),
        const GoalsSection(),
        const SizedBox(height: AppSpacing.lg),
        RecentActivitySection(count: summary.recentActivityCount),
      ],
    );
  }
}
