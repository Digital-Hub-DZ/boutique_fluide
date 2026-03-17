import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Colour palette ─────────────────────────────────────────────────────────────
abstract class AppColors {
  static const midnight = Color(0xFF1A1A2E);
  static const charcoal = Color(0xFF4A4A5A);
  static const pureWhite = Color(0xFFFFFFFF);
  static const warmBeige = Color(0xFFF5F0E8);
  static const gold = Color(0xFFC9A84C);
  static const terracotta = Color(0xFFD4693C);
  static const success = Color(0xFF2E7D5A);
  static const error = Color(0xFFB00020);
  static const whatsApp = Color(0xFF25D366);
  static const lightGrey = Color(0xFFF8F8F8);
}

// ── Spacing ────────────────────────────────────────────────────────────────────
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

// ── Radius ─────────────────────────────────────────────────────────────────────
abstract class AppRadius {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 20;
  static const double xxl = 28;
}

// ── Theme ──────────────────────────────────────────────────────────────────────
final ThemeData boutiqueTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.midnight,
    surface: AppColors.pureWhite,
    onSurface: AppColors.midnight,
  ),
  scaffoldBackgroundColor: AppColors.warmBeige,
  textTheme: GoogleFonts.dmSansTextTheme().copyWith(
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.midnight,
    ),
    headlineMedium: GoogleFonts.dmSans(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.midnight,
    ),
    titleLarge: GoogleFonts.dmSans(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.midnight,
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.midnight,
    ),
    titleSmall: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.midnight,
    ),
    bodyLarge: GoogleFonts.dmSans(fontSize: 16, color: AppColors.midnight),
    bodyMedium: GoogleFonts.dmSans(fontSize: 14, color: AppColors.midnight),
    labelSmall: GoogleFonts.dmSans(fontSize: 11, color: AppColors.charcoal),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.warmBeige,
    foregroundColor: AppColors.midnight,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.midnight,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.pureWhite,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      side: BorderSide(color: AppColors.charcoal.withValues(alpha: 0.10)),
    ),
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.pureWhite,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: AppColors.charcoal.withValues(alpha: 0.20)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: AppColors.charcoal.withValues(alpha: 0.20)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: AppColors.midnight, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    labelStyle: GoogleFonts.dmSans(color: AppColors.charcoal),
    hintStyle: GoogleFonts.dmSans(color: AppColors.charcoal),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.midnight,
      foregroundColor: AppColors.pureWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 15),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.pureWhite,
    elevation: 0,
    selectedLabelStyle: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600),
    unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 11),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
    backgroundColor: AppColors.midnight,
    contentTextStyle: GoogleFonts.dmSans(color: AppColors.pureWhite),
  ),
);
