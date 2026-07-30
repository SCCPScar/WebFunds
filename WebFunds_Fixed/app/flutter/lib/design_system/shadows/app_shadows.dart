import 'package:flutter/widgets.dart';

class AppShadows {
  const AppShadows._();

  static List<BoxShadow> soft(bool isDark) => [
    BoxShadow(
      color: (isDark ? const Color(0xFF000000) : const Color(0xFF14171F))
          .withValues(alpha: isDark ? 0.24 : 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> medium(bool isDark) => [
    BoxShadow(
      color: (isDark ? const Color(0xFF000000) : const Color(0xFF14171F))
          .withValues(alpha: isDark ? 0.32 : 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> dialog(bool isDark) => [
    BoxShadow(
      color: (isDark ? const Color(0xFF000000) : const Color(0xFF14171F))
          .withValues(alpha: isDark ? 0.45 : 0.12),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];
}
