import 'package:flutter/animation.dart';

class MotionCurves {
  const MotionCurves._();

  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeOutExpo = Curves.easeOutExpo;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve standard = fastOutSlowIn;
}
