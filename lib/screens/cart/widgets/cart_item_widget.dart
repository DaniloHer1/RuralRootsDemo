import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/cart_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Imagen del producto
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.lightGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.product.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.eco,
                        color: AppColors.primaryGreen,
                        size: 30,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.eco,
                    color: AppColors.primaryGreen,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 16),

          // Info del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.formatWithUnit(
                    item.product.price,
                    item.product.unit,
                  ),
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: ${CurrencyFormatter.format(item.total)}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),

          // Controles de cantidad
          Column(
            children: [
              _QuantityControls(
                quantity: item.quantity,
                onDecrement: () {
                  cartService.updateQuantity(
                    item.product.id,
                    item.farmerId,
                    item.quantity - 1,
                  );
                },
                onIncrement: () {
                  cartService.updateQuantity(
                    item.product.id,
                    item.farmerId,
                    item.quantity + 1,
                  );
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  cartService.removeItem(item.product.id, item.farmerId);
                },
                child: Text(
                  'Eliminar',
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityControls({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            color: AppColors.textPrimary,
            onPressed: onDecrement,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            color: AppColors.primaryGreen,
            onPressed: onIncrement,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }
}