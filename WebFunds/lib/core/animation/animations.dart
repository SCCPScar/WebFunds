import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'motion_curves.dart';
import 'motion_durations.dart';

/// Reusable, declarative micro-interaction helpers built on
/// `flutter_animate`.
extension WebFundsAnimations on Widget {
  /// Fades and slightly slides the widget in.
  Widget fadeSlideIn({Duration? delay}) {
    return animate(delay: delay ?? Duration.zero)
        .fadeIn(
          duration: MotionDurations.normal,
          curve: MotionCurves.easeOutCubic,
        )
        .slideY(
          begin: 0.04,
          end: 0,
          duration: MotionDurations.normal,
          curve: MotionCurves.easeOutCubic,
        );
  }

  /// Simple, quick fade — used for state changes.
  Widget quickFadeIn() {
    return animate().fadeIn(
      duration: MotionDurations.fast,
      curve: MotionCurves.standard,
    );
  }
}