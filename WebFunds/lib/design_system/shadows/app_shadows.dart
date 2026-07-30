import 'package:flutter/widgets.dart';

/// WebFunds shadow tokens — soft, low-opacity only. Used directly in
/// `BoxDecoration.boxShadow` for custom surfaces (not Material's
/// `elevation`, which produces harsher shadows).
class AppShadows {
  const AppShadows._();

  /// Barely-there lift. Use for resting cards.
  static List<BoxShadow> soft(bool isDark) => [
    BoxShadow(
      color: (isDark ? const Color(0xFF000000) : const Color(0xFF14171F))
          .withValues(alpha: isDark ? 0.24 : 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Slightly stronger lift. Use for pressed/focused/floating elements.
  static List<BoxShadow> medium(bool isDark) => [
    BoxShadow(
      color: (isDark ? const Color(0xFF000000) : const Color(0xFF14171F))
          .withValues(alpha: isDark ? 0.32 : 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Reserved for modals/dialogs only.
  static List<BoxShadow> dialog(bool isDark) => [
    BoxShadow(
      color: (isDark ? const Color(0xFF000000) : const Color(0xFF14171F))
          .withValues(alpha: isDark ? 0.45 : 0.12),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];
}