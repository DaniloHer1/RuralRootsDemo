import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rural_roots_demo1/screens/cart/widgets/farmer_group_widget.dart';
import 'package:rural_roots_demo1/shared/widget/custom_button.dart';
import 'package:rural_roots_demo1/shared/widget/empty_state.dart';
import '../../../services/cart_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../themes/app_decorations.dart';



class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showClearCartDialog(BuildContext context, CartService cartService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vaciar carrito', style: AppTextStyles.subheadline),
        content: Text(
          '¿Estás seguro de que quieres eliminar todos los productos?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              cartService.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrito vaciado'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: Text(
              'Vaciar',
              style: AppTextStyles.body.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cartService, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Mi Carrito', style: AppTextStyles.subheadline),
            centerTitle: true,
            actions: [
              if (cartService.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showClearCartDialog(context, cartService),
                ),
            ],
          ),
          body: cartService.isEmpty
              ? EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Tu carrito está vacío',
                  subtitle: 'Añade productos desde el mapa',
                  action: CustomButton(
                    text: 'Explorar productos',
                    icon: Icons.map,
                    onPressed: () => Navigator.pop(context),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ..._buildFarmerGroups(cartService),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                    _CartBottomBar(cartService: cartService),
                  ],
                ),
        );
      },
    );
  }

  List<Widget> _buildFarmerGroups(CartService cartService) {
    final grouped = cartService.groupByFarmer();
    return grouped.entries.map((entry) {
      final farmerId = entry.key;
      final items = entry.value;
      return FarmerGroupWidget(
        farmerId: farmerId,
        farmerName: items.first.farmerName,
        items: items,
        total: cartService.getTotalByFarmer(farmerId),
      );
    }).toList();
  }
}