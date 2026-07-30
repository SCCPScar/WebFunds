import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'motion_curves.dart';
import 'motion_durations.dart';

/// Reusable page transition builders for GoRouter's `pageBuilder`.
class PageTransitions {
  const PageTransitions._();

  /// Simple fade transition. Use for tab switches / low-hierarchy nav.
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

  /// Fade combined with a subtle upward slide. Use for pushing a new
  /// screen onto the stack.
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