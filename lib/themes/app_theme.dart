import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primaryGreen,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryGreen,
    primary: AppColors.primaryGreen,
    secondary: AppColors.lightGreen,
  ),
  textTheme: const TextTheme(
    headlineLarge: AppTextStyles.headline,
    titleMedium: AppTextStyles.subheadline,
    bodyMedium: AppTextStyles.body,
    bodySmall: AppTextStyles.bodySecondary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryGreen,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
);