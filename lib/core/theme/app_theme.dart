import 'package:flutter/material.dart';

class AppColors {
  static const Color forestGreen = Color(0xFF1B3D39);
  static const Color sageTeal = Color(0xFF507E7B);
  static const Color darkText = Color(0xFF1A2E2C);

  static const Color gradientStart = Color(0xFFE2E7E6);
  static const Color gradientEnd = Color(0xFFBAC3C1);
  static const Color gradientDeep = Color(0xFF8C9A98);

  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF6B7B79);
  static const Color success = Color(0xFF4CAF7D);
  static const Color error = Color(0xFFE57373);

  static const Color primary = forestGreen;
  static const Color secondary = sageTeal;
  static const Color background = forestGreen;
  static const Color tertiary = forestGreen;
  static const Color surface = Color(0xFFEEF4E0);
  static const Color dark = darkText;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.forestGreen,
      primaryColor: AppColors.forestGreen,
      colorScheme: const ColorScheme.light(
        primary: AppColors.forestGreen,
        secondary: AppColors.sageTeal,
        error: AppColors.error,
        surface: AppColors.white,
      ),
      fontFamily: 'PlusJakartaSans',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.06),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        hintStyle: TextStyle(
            color: AppColors.white.withValues(alpha: 0.35), fontSize: 14),
        prefixIconColor: AppColors.white.withValues(alpha: 0.4),
        suffixIconColor: AppColors.white.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: AppColors.white.withValues(alpha: 0.05), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.sageTeal, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.forestGreen,
          minimumSize: const Size(double.infinity, 48),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
