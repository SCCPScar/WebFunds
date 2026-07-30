import 'package:flutter/material.dart';

import '../design_system/colors/app_colors.dart';
import '../design_system/opacity/app_opacity.dart';
import '../design_system/radius/app_radius.dart';
import '../design_system/spacing/app_spacing.dart';
import '../design_system/typography/app_typography.dart';

// NOTE on AppShadows: Flutter's built-in Card/Material `elevation` paints
// its own shadow shape and cannot accept an arbitrary `BoxShadow` list,
// so the soft shadow tokens are not wired in here. They are meant for
// custom Container/DecoratedBox surfaces. CardThemeData.elevation stays
// at 0 on purpose.

/// WebFunds application theme. Builds `ThemeData` for both Light and Dark
/// mode from the Design System tokens. Dark Mode is the primary
/// experience. No widget should read colors/spacing/radii directly from
/// the design_system classes for anything visual — always go through
/// `Theme.of(context)`.
class AppTheme {
  const AppTheme._();

  static ThemeData get dark => _build(brightness: Brightness.dark);

  static ThemeData get light => _build(brightness: Brightness.light);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final background = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceElevated =
        isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final textTheme = AppTypography.textTheme(textPrimary, textSecondary);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.electricBlue,
      onPrimary: Colors.white,
      secondary: AppColors.softCyan,
      onSecondary: AppColors.darkBackground,
      error: AppColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: border,
      splashFactory: InkSparkle.splashFactory,
      textTheme: textTheme,

      cardTheme: CardThemeData(
        color: surfaceElevated,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.electricBlue.withValues(alpha: AppOpacity.disabled);
            }
            return AppColors.electricBlue;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          minimumSize: WidgetStateProperty.all(const Size.fromHeight(48)),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: border),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.electricBlue,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        constraints: const BoxConstraints(minHeight: 48),
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: AppColors.electricBlue, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: AppColors.danger),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevated,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.electricBlue,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: AppColors.electricBlue.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return (textTheme.bodySmall ?? const TextStyle()).copyWith(
            color: selected ? AppColors.electricBlue : textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? AppColors.electricBlue : textSecondary);
        }),
      ),

      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
    );
  }
}