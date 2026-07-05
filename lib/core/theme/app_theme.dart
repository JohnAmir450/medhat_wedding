import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Luxury "Deep Emerald & Gold" palette.
/// Swap these values for a "Champagne & Rose Gold" look if preferred —
/// every widget in the app reads colors from here, nothing is hardcoded.
class AppColors {
  AppColors._();

  static const Color deepNavy = Color(0xFF0B2A25); // primary background
  static const Color emerald = Color(0xFF16433B); // secondary surface
  static const Color gold = Color(0xFFC9A66B); // accent
  static const Color goldLight = Color(0xFFE7D5B0);
  static const Color ivory = Color(0xFFFBF7EF); // light surface / text on dark
  static const Color champagne = Color(0xFFF3E9D6);
  static const Color textMuted = Color(0xFFCBD5CF);
  static const Color error = Color(0xFFB3555C);
  static const Color success = Color(0xFF6B9080);
}

class AppTextStyles {
  AppTextStyles._();

  /// Script font for names / hero titles.
  static TextStyle script({double size = 64, Color? color}) =>
      GoogleFonts.greatVibes(
        fontSize: size,
        color: color ?? AppColors.gold,
        height: 1.1,
      );

  /// Elegant serif for headings.
  static TextStyle heading({
    double size = 32,
    FontWeight weight = FontWeight.w600,
    Color? color,
  }) =>
      GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: weight,
        color: color ?? AppColors.ivory,
        letterSpacing: 0.5,
      );

  /// Body copy.
  static TextStyle body({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
  }) =>
      GoogleFonts.lato(
        fontSize: size,
        fontWeight: weight,
        color: color ?? AppColors.textMuted,
        height: height ?? 1.6,
      );

  /// Small caps / label / eyebrow text.
  static TextStyle label({double size = 13, Color? color}) => GoogleFonts.lato(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.gold,
        letterSpacing: 3,
      );
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.deepNavy,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.gold,
        secondary: AppColors.emerald,
        surface: AppColors.emerald,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.latoTextTheme(base.textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.deepNavy,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: AppTextStyles.label(color: AppColors.deepNavy),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.emerald.withOpacity(0.4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.gold, width: 0.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:
              BorderSide(color: AppColors.gold.withOpacity(0.4), width: 0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
        ),
        hintStyle: AppTextStyles.body(color: AppColors.textMuted),
      ),
      dividerColor: AppColors.gold.withOpacity(0.3),
    );
  }
}
