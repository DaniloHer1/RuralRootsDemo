import 'package:flutter/material.dart';
import '../../../models/order.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class StatusChip extends StatelessWidget {
  final OrderStatus status;
  final bool showIcon;

  const StatusChip({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.accentOrange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.delivered:
        return AppColors.primaryGreen;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.delivered:
        return Icons.task_alt;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(_getStatusIcon(), size: 16, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            status.displayName,
            style: AppTextStyles.bodySecondary.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
