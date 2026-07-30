import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';

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
