import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF4A7C7E);
  static const Color primaryLight = Color(0xFF6B9E9F);
  static const Color primaryDark = Color(0xFF2D5A5C);
  static const Color accent = Color(0xFFF5A623);
  static const Color background = Color(0xFFF8F8F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF8A8A8A);
  static const Color greyLight = Color(0xFFE8E8E8);
  static const Color greyBg = Color(0xFFF2F2F2);
  static const Color red = Color(0xFFE74C3C);
  static const Color green = Color(0xFF27AE60);
  static const Color star = Color(0xFFFFC107);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),
        titleTextStyle: GoogleFonts.poppins(
          color: black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: greyBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
