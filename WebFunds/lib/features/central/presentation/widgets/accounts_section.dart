import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';

/// Placeholder — no Accounts domain wiring into Central exists yet
/// (Milestone 01.6 built the Accounts feature itself; wiring it into
/// this section is a separate, later step). Isolated as its own section
/// exactly so that step only needs to fill in this widget.
class AccountsSection extends StatelessWidget {
  const AccountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(AppIcons.finances, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text('Contas chega numa próxima milestone', style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}