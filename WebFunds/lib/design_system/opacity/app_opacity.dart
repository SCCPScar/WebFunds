/// WebFunds opacity tokens. Centralizes every "faded" state so no widget
/// hardcodes a magic opacity value.
class AppOpacity {
  const AppOpacity._();

  static const double disabled = 0.38;
  static const double muted = 0.60;
  static const double hover = 0.08;
  static const double pressed = 0.12;
  static const double divider = 0.12;
  static const double scrim = 0.55;

  /// Glass effect surfaces — allowed only for navigation bars, floating
  /// panels, and dialog backgrounds.
  static const double glass = 0.72;
}