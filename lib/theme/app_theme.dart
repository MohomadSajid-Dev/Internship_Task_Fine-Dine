import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const espressoBrown = Color(0xFF3A2416);
  static const warmGold = Color(0xFFC9A66B);
  static const cream = Color(0xFFFFF9F3);
  static const cardWhite = Color(0xFFFFFFFF);
  static const charcoal = Color(0xFF1D1D1D);
  static const successGreen = Color(0xFF2E7D32);
  static const softBeige = Color(0xFFF2E6D8);
  static const textSecondary = Color(0xFF6B6B6B);
}

class AppTheme {
  static const double radiusCard = 24;
  static const double radiusButton = 18;
  static const double spacing = 8;

  static BoxShadow softShadow = BoxShadow(
    color: AppColors.espressoBrown.withValues(alpha: 0.08),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );

  static BoxShadow cardShadow = BoxShadow(
    color: AppColors.espressoBrown.withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  static ThemeData get lightTheme {
    final baseText = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.espressoBrown,
        primary: AppColors.espressoBrown,
        secondary: AppColors.warmGold,
        surface: AppColors.cream,
        onPrimary: Colors.white,
        onSecondary: AppColors.charcoal,
      ),
      textTheme: baseText.copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.charcoal,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.charcoal,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.charcoal,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.espressoBrown,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.espressoBrown,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          side: const BorderSide(color: AppColors.warmGold, width: 1.5),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(color: AppColors.softBeige, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: const BorderSide(color: AppColors.warmGold, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
        labelStyle: GoogleFonts.inter(color: AppColors.textSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardWhite,
        selectedColor: AppColors.espressoBrown,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          side: const BorderSide(color: AppColors.softBeige),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }
}
