/// WebFunds elevation tokens. Material's default elevation scale
/// contradicts the "soft shadows, light interface" principle, so
/// `Card`/`AppBar`/dialogs use `elevation: 0` plus [AppShadows] instead.
/// These numeric values exist only for rare cases a raw elevation number
/// is needed (e.g. a third-party widget's `elevation` parameter).
class AppElevation {
  const AppElevation._();

  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
}