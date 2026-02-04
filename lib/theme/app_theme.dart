import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1E40AF); // Biru Gelap (Primary)
  static const Color primary = Color(0xFF3B82F6); // Biru Cerah (Secondary)
  static const Color primaryLight = Color(0xFFDEEAF8); // Biru sangat cerah
  static const Color accent = Color(0xFF8B5CF6); // Ungu (Accent)
  static const Color navy = Color(0xFF1E40AF); // Biru Gelap
  static const Color lightBlue = Color(0xFF3B82F6); // Biru Cerah
  static const Color success = Color(0xFF10B981); // Hijau
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color danger = Color(0xFFEF4444); // Merah
  static const Color grey = Color(0xFF757575);
  static const Color muted = Color(0xFF999999);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color extraLight = Color(0xFFF8FAFC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
      scaffoldBackgroundColor: AppColors.extraLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.black, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.grey, fontSize: 14),
      ),
    );
  }
}
