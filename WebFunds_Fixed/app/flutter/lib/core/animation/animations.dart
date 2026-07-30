import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'motion_curves.dart';
import 'motion_durations.dart';

extension WebFundsAnimations on Widget {
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

  Widget quickFadeIn() {
    return animate().fadeIn(
      duration: MotionDurations.fast,
      curve: MotionCurves.standard,
    );
  }
}
