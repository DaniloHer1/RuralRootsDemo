import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppButtonStyles {
  static final ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryGreen,
    foregroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    textStyle: AppTextStyles.buttonText,
  );

  static final ButtonStyle secondary = OutlinedButton.styleFrom(
    side: BorderSide(color: AppColors.primaryGreen),
    foregroundColor: AppColors.primaryGreen,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    textStyle: AppTextStyles.body,
  );

  static final ButtonStyle icon = ElevatedButton.styleFrom(
    backgroundColor: AppColors.lightGreen,
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(12),
  );
}