/// WebFunds motion duration tokens. No animation duration may be
/// hardcoded inside widgets — everything reuses these tokens.
class MotionDurations {
  const MotionDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration modalTransition = Duration(milliseconds: 250);
  static const Duration snackbar = Duration(milliseconds: 200);
  static const Duration hover = Duration(milliseconds: 120);
  static const Duration pressed = Duration(milliseconds: 80);

  /// Minimum time the Splash screen stays visible, regardless of how fast
  /// startup tasks resolve — runs concurrently with them. See
  /// `lib/startup/`.
  static const Duration splashMinimumDwell = Duration(milliseconds: 900);
}