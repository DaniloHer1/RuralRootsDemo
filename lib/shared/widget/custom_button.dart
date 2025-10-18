import 'package:flutter/material.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

enum ButtonType { primary, secondary, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool expanded;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.expanded = false,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.primaryGreen;
      case ButtonType.secondary:
        return Colors.transparent;
      case ButtonType.danger:
        return Colors.red;
    }
  }

  Color _getTextColor() {
    return type == ButtonType.secondary ? AppColors.primaryGreen : AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    final button = type == ButtonType.secondary
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: type == ButtonType.danger ? Colors.red : AppColors.primaryGreen,
              ),
              foregroundColor: type == ButtonType.danger ? Colors.red : AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
            child: _buildContent(),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBackgroundColor(),
              foregroundColor: _getTextColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
            child: _buildContent(),
          );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.white,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.buttonText),
        ],
      );
    }

    return Text(text, style: AppTextStyles.buttonText);
  }
}
