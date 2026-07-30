import 'package:flutter/animation.dart';

/// WebFunds motion curve tokens. Bounce/elastic curves are forbidden in
/// the primary flow.
class MotionCurves {
  const MotionCurves._();

  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeOutExpo = Curves.easeOutExpo;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  static const Curve standard = fastOutSlowIn;
}