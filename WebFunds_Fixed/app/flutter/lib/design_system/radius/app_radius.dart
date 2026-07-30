import 'package:flutter/widgets.dart';

class AppRadius {
  const AppRadius._();

  static const double card = 16;
  static const double button = 14;
  static const double input = 14;
  static const double dialog = 20;
  static const double chart = 16;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(card));
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(button));
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(input));
  static const BorderRadius dialogRadius = BorderRadius.all(Radius.circular(dialog));
  static const BorderRadius chartRadius = BorderRadius.all(Radius.circular(chart));
}
