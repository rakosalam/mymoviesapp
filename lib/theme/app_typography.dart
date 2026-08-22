import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle displayLg(Color color) => GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 40 / 32,
    letterSpacing: -0.02 * 32,
    color: color,
  );

  static TextStyle headlineLgMobile(Color color) => GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 36 / 28,
    color: color,
  );

  static TextStyle headlineMd(Color color) => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    color: color,
  );

  static TextStyle headlineSm(Color color) => GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 28 / 20,
    color: color,
  );

  static TextStyle bodyLg(Color color) => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: color,
  );

  static TextStyle bodyMd(Color color) => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: color,
  );

  static TextStyle labelMd(Color color) => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.05 * 12,
    color: color,
  );

  static TextTheme textTheme(Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      displayLarge: displayLg(onSurface),
      headlineLarge: headlineLgMobile(onSurface),
      headlineMedium: headlineMd(onSurface),
      headlineSmall: headlineSm(onSurface),
      bodyLarge: bodyLg(onSurface),
      bodyMedium: bodyMd(onSurface),
      bodySmall: bodyMd(onSurfaceVariant),
      labelMedium: labelMd(onSurfaceVariant),
    );
  }
}
