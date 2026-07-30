import 'package:flutter/material.dart';

import '../../core/errors/failure.dart';
import '../../design_system/icons/app_icons.dart';
import '../../design_system/spacing/app_spacing.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.failure, this.onRetry});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.error, size: 40, color: theme.colorScheme.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              failure.message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(onPressed: onRetry, child: const Text('Tentar novamente')),
            ],
          ],
        ),
      ),
    );
  }
}
