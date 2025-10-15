// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/services/cart_service.dart';
import 'package:rural_roots_demo1/screens/checkout_screen.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mi Carrito',
          style: AppTextStyles.subheadline,
        ),
        centerTitle: true,
        actions: [
          if (_cartService.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                _showClearCartDialog();
              },
            ),
        ],
      ),
      body: _cartService.itemCount == 0
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ..._buildGroupedItems(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 24),
          Text(
            'Tu carrito está vacío',
            style: AppTextStyles.headline.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Añade productos desde el mapa',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.map),
            label: Text('Explorar productos', style: AppTextStyles.buttonText),
            style: AppButtonStyles.primary,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedItems() {
    final grouped = _cartService.groupByFarmer();
    final widgets = <Widget>[];

    grouped.forEach((farmerId, items) {
      final farmerName = items.first.farmerName;
      final farmerTotal = items.fold<double>(
        0,
        (sum, item) => sum + item.total,
      );

      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.border.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del agricultor
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.store,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farmerName,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${items.length} producto(s) • €${farmerTotal.toStringAsFixed(2)}',
                            style: AppTextStyles.bodySecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Productos del agricultor
              ...items.map((item) => _buildCartItem(item)),
            ],
          ),
        ),
      );
    });

    return widgets;
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
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
            child: const Icon(
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
                  item.productName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '€${item.price.toStringAsFixed(2)}/${item.unit}',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: €${item.total.toStringAsFixed(2)}',
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
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      color: AppColors.textPrimary,
                      onPressed: () {
                        setState(() {
                          if (item.quantity > 1) {
                            _cartService.updateQuantity(
                              item.productId,
                              item.farmerId,
                              item.quantity - 1,
                            );
                          }
                        });
                      },
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.quantity}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      color: AppColors.primaryGreen,
                      onPressed: () {
                        setState(() {
                          _cartService.updateQuantity(
                            item.productId,
                            item.farmerId,
                            item.quantity + 1,
                          );
                        });
                      },
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _cartService.removeItem(item.productId, item.farmerId);
                  });
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

  Widget _buildBottomBar() {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '€${_cartService.totalAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.headline.copyWith(
                        fontSize: 24,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    );
                  },
                  style: AppButtonStyles.primary,
                  child: Row(
                    children: [
                      Text(
                        'Hacer Pedido',
                        style: AppTextStyles.buttonText,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog() {
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
              setState(() {
                _cartService.clear();
              });
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
              style: AppTextStyles.body.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}