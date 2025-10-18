import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rural_roots_demo1/services/cart_service.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';
import 'package:rural_roots_demo1/shared/widget/custom_button.dart';

class _CartBottomBar extends StatelessWidget {
  final CartService cartService;

  const _CartBottomBar({required this.cartService});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total', style: AppTextStyles.bodySecondary),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(cartService.totalAmount),
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 24,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            CustomButton(
              text: 'Hacer Pedido',
              icon: Icons.arrow_forward,
              onPressed: () => context.push('/checkout'),
            ),
          ],
        ),
      ),
    );
  }
}