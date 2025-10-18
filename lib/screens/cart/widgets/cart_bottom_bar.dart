import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rural_roots_demo1/core/utils/currency_formater.dart';

import '../../../services/cart_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../shared/widget/custom_button.dart';


/// Barra inferior del carrito que muestra el total y botón de checkout
class CartBottomBar extends StatelessWidget {
  final CartService cartService;

  const CartBottomBar({
    super.key,
    required this.cartService,
  });

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
            // Total
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.bodySecondary,
                ),
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
            
            // Botón de checkout
            CustomButton(
              text: 'Hacer Pedido',
              icon: Icons.arrow_forward,
              onPressed: () {
                // Navegar a checkout
                context.push('/checkout');
              },
            ),
          ],
        ),
      ),
    );
  }
}