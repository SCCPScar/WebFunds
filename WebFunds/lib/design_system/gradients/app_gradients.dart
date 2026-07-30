import 'package:flutter/widgets.dart';

import '../colors/app_colors.dart';

/// WebFunds gradient tokens. One original, restrained brand gradient —
/// use sparingly, never as a default.
class AppGradients {
  const AppGradients._();

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.electricBlue, AppColors.softCyan],
  );

  static const LinearGradient primarySubtle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.electricBlueDark, AppColors.darkSurfaceElevated],
  );
}