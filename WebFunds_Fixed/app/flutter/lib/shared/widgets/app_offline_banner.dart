import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/animation/motion_tokens.dart';
import '../../design_system/icons/app_icons.dart';
import '../../design_system/spacing/app_spacing.dart';
import '../../services/network/connectivity_service.dart';

class AppOfflineBanner extends ConsumerWidget {
  const AppOfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityStatusProvider).valueOrNull;

    if (isOnline != false) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: MotionDurations.normal,
      curve: MotionCurves.standard,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      color: theme.colorScheme.error,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(AppIcons.error, size: 16, color: Colors.white),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Sem ligação à internet — a mostrar dados guardados.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
