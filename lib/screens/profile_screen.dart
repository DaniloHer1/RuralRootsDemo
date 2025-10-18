// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/services/user_service.dart';
import 'package:rural_roots_demo1/screens/products/add_product_screen.dart';
import 'package:rural_roots_demo1/screens/products/my_products_screen.dart';
import 'package:rural_roots_demo1/screens/orders/my_orders_screen.dart';
import 'package:rural_roots_demo1/screens/orders/received_order_screen.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMap;

  const ProfileScreen({super.key, this.onNavigateToMap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _userService.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    _userService.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isAgricultor = _userService.isAgricultor;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Mi Perfil',
          style: AppTextStyles.subheadline,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.border.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userService.name,
                          style: AppTextStyles.subheadline,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAgricultor ? 'Agricultora desde 2018' : 'Comprador',
                          style: AppTextStyles.bodySecondary,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.accentOrange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '4.9',
                              style: AppTextStyles.bodySecondary.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(47 valoraciones)',
                              style: AppTextStyles.bodySecondary.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  OutlinedButton(
                    onPressed: () {},
                    style: AppButtonStyles.secondary,
                    child: Text(
                      'Editar',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (isAgricultor) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.inventory_2_outlined,
                        value: '28',
                        label: 'Productos',
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.shopping_bag_outlined,
                        value: '156',
                        label: 'Ventas',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.favorite_border,
                        value: '89',
                        label: 'Seguidores',
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Acciones rápidas',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildActionTile(
                    icon: Icons.add_circle_outline,
                    title: isAgricultor ? 'Publicar cosecha' : 'Buscar productos',
                    onTap: () {
                      if (isAgricultor) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProductScreen(),
                          ),
                        );
                      } else {
                        widget.onNavigateToMap?.call();
                      }
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.inventory_2_outlined,
                    title: isAgricultor ? 'Gestionar productos' : 'Mis pedidos',
                    onTap: () {
                      if (isAgricultor) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyProductsScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyOrdersScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.star_outline,
                    title: 'Ver valoraciones',
                    onTap: () {},
                  ),
                  _buildActionTile(
                    icon: Icons.history,
                    title: isAgricultor ? 'Historial de ventas' : 'Historial de compras',
                    onTap: () {
                      if (isAgricultor) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReceivedOrdersScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyOrdersScreen(),
                          ),
                        );
                      }
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headline,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primaryGreen),
          title: Text(title, style: AppTextStyles.body),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(height: 1, color: AppColors.border, indent: 56),
      ],
    );
  }
}