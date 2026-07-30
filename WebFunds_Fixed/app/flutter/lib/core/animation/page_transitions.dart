import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'motion_curves.dart';
import 'motion_durations.dart';

class PageTransitions {
  const PageTransitions._();

  static CustomTransitionPage<void> fade({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: MotionDurations.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: MotionCurves.standard,
          ),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<void> fadeThroughSlide({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: MotionDurations.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: MotionCurves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
