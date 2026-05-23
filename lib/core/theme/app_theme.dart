import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1B2855);
  static const Color primaryDark = Color(0xFF111B3D);
  static const Color accent = Color(0xFF2540A8);
  static const Color background = Color(0xFFF3F5F9);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF101522);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color danger = Color(0xFFE11D48);
  static const Color infoBg = Color(0xFFEFF1F7);
  static const Color fieldFill = Color.fromARGB(255, 239, 239, 240);
  static const Color skeleton = Color.fromARGB(255, 232, 233, 235);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.primary),
        titleTextStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
    );
  }
}
