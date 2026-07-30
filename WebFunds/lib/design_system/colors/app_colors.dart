import 'package:flutter/material.dart';

/// WebFunds color tokens. Original palette — no copyrighted Spider-Man/
/// Marvel color references, only the documented emotional direction
/// (calm, precise, scientific, blue-lit). Never use these values directly
/// in widgets — always go through the theme (`lib/theme/app_theme.dart`).
class AppColors {
  const AppColors._();

  // --- Primary Accent: Electric Blue ---
  static const Color electricBlue = Color(0xFF3D7DFF);
  static const Color electricBlueDark = Color(0xFF2E5FE0);
  static const Color electricBlueLight = Color(0xFF6E9BFF);

  // --- Secondary Accent: Soft Cyan ---
  static const Color softCyan = Color(0xFF5CE1E6);
  static const Color softCyanDark = Color(0xFF3BB8BD);

  // --- Semantic colors ---
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFFF453A);

  // --- Dark theme surfaces (primary experience) ---
  static const Color darkBackground = Color(0xFF0B0D12);
  static const Color darkSurface = Color(0xFF14171F);
  static const Color darkSurfaceElevated = Color(0xFF1C202B);
  static const Color darkBorder = Color(0xFF272C38);

  // --- Light theme surfaces ---
  static const Color lightBackground = Color(0xFFF5F6F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF0F1F4);
  static const Color lightBorder = Color(0xFFE1E3E8);

  // --- Text (dark theme) ---
  static const Color darkTextPrimary = Color(0xFFF5F6F8);
  static const Color darkTextSecondary = Color(0xFFA0A5B1);
  static const Color darkTextTertiary = Color(0xFF6B7080);

  // --- Text (light theme) ---
  static const Color lightTextPrimary = Color(0xFF14171F);
  static const Color lightTextSecondary = Color(0xFF565B68);
  static const Color lightTextTertiary = Color(0xFF8B909C);
}