import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class BarcaTypography {
  // Headlines - Space Grotesk
  static TextStyle headlineXl = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: BarcaColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle headlineLg = GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: BarcaColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle headlineMd = GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: BarcaColors.textPrimary,
  );

  // Body - Inter
  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: BarcaColors.textPrimary,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BarcaColors.textSecondary,
    height: 1.4,
  );

  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: BarcaColors.textMuted,
  );

  // Monospace Telemetry - JetBrains Mono
  static TextStyle telemetryLg = GoogleFonts.jetBrainsMono(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: BarcaColors.senyeraGold,
  );

  static TextStyle telemetryMd = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: BarcaColors.textPrimary,
  );

  static TextStyle telemetrySm = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: BarcaColors.textMuted,
  );
}
