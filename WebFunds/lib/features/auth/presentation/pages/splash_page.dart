import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/animation/animations.dart';
import '../../../../core/animation/motion_tokens.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';

/// The Splash screen. No navigation logic lives here — the Route Guard
/// (`router/app_router.dart`'s `redirect`, driven by `AuthGateController`
/// and `AppNavigationResolver`) moves the person along automatically once
/// startup resolves. This screen only needs to exist and look good while
/// that happens.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.central, size: 56, color: theme.colorScheme.primary)
                .animate()
                .fadeIn(duration: MotionDurations.slow)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                  duration: MotionDurations.slow,
                  curve: MotionCurves.easeOutCubic,
                ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'WebFunds',
              style: theme.textTheme.headlineMedium,
            ).fadeSlideIn(delay: const Duration(milliseconds: 200)),
          ],
        ),
      ),
    );
  }
}