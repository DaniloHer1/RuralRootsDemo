import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  // Cards
  static BoxDecoration card = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.border.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration cardHighlight = card.copyWith(
    border: Border.all(color: AppColors.primaryGreen, width: 2),
  );

  static BoxDecoration cardAlert = card.copyWith(
    border: Border.all(color: AppColors.accentOrange, width: 2),
  );

  // Input Fields
  static InputDecoration inputDecoration({
    required String label,
    String? hint,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary) : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  // Containers
  static BoxDecoration infoContainer = BoxDecoration(
    color: AppColors.lightGreen.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.lightGreen.withOpacity(0.5),
      width: 1,
    ),
  );

  static BoxDecoration warningContainer = BoxDecoration(
    color: Colors.amber.shade50,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.amber.shade200),
  );
}
