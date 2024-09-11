// lib/theme.dart

import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1E88E5); // Deep Blue
  static const Color accentColor = Color(0xFFFFB300);  // Yellow-Orange
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light Grey
}

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          //: Colors.white,
        ),
      ),
    );
  }
}
