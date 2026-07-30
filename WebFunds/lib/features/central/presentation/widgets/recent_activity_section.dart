import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_empty_state.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: AppEmptyState(message: 'Sem atividade recente.', icon: AppIcons.activity),
        ),
      );
    }

    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(AppIcons.activity, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                '$count atividades recentes — lista chega numa próxima milestone.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}