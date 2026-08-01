import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// WebFunds typography tokens. Primary Font: Inter.
class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(Color primary, Color secondary) {
    // `GoogleFonts.interTextTheme()` with no argument bases itself on
    // `ThemeData.light().textTheme` regardless of which brightness this
    // theme is actually building for — every variant not explicitly
    // overridden below keeps that light-mode (near-black) color, which is
    // nearly invisible on Dark Mode's near-black backgrounds. Every
    // variant is overridden here for exactly that reason — none may be
    // left to fall through to the `base` default.
    final base = GoogleFonts.interTextTheme();

    return base.copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.w400, color: primary),
      displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w400, color: primary),
      displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w400, color: primary),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primary,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primary,
        height: 1.25,
      ),
      headlineSmall: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: primary),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: primary),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: secondary),
    );
  }
}