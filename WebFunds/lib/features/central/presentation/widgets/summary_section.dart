import 'package:flutter/material.dart';

import '../../../../core/animation/animations.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/models/money.dart';

/// The only section with real, calculated content in the current
/// implementation.
class SummarySection extends StatelessWidget {
  const SummarySection({super.key, required this.totalBalance});

  final Money totalBalance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo total', style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(totalBalance.format(), style: theme.textTheme.headlineLarge),
          ],
        ),
      ),
    ).fadeSlideIn();
  }
}