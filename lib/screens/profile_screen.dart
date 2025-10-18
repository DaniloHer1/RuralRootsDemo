// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

import 'package:rural_roots_demo1/services/user_service.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMap;

  const ProfileScreen({super.key, this.onNavigateToMap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  

  @override
  void initState() {
    super.initState();
  
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userService = Provider.of<UserService>(context, listen: false);
      userService.addListener(_onUserChanged);
    });
  }

  @override
  void dispose() {
    
    final userService = Provider.of<UserService>(context, listen: false);
    userService.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() {
    // Actualizar la UI cuando cambie el usuario
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
   
    final userService = context.watch<UserService>();
    final isAgricultor = userService.isFarmer;

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
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              // TODO: Implementar notificaciones
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función en desarrollo')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Card de perfil
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
                  // Avatar
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

                  // Información del usuario
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userService.currentUser?.name ?? 'Usuario',
                          style: AppTextStyles.subheadline,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isAgricultor 
                                  ? Icons.agriculture 
                                  : Icons.shopping_bag,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isAgricultor ? 'Agricultor' : 'Comprador',
                              style: AppTextStyles.bodySecondary.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Botón de editar perfil
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primaryGreen,
                    ),
                    onPressed: () {
                      // TODO: Navegar a editar perfil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función en desarrollo'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Switch de rol (Agricultor/Comprador)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    isAgricultor 
                        ? Icons.agriculture 
                        : Icons.shopping_bag,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cambiar modo',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Alterna entre agricultor y comprador',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isAgricultor,
                    onChanged: (value) {
                      userService.toggleRole();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? '🌾 Cambiado a modo Agricultor'
                                : '🛒 Cambiado a modo Comprador',
                          ),
                          backgroundColor: AppColors.primaryGreen,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    activeColor: AppColors.primaryGreen,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Opciones del perfil
            if (isAgricultor) ...[
              // Opciones de Agricultor
              _buildProfileOption(
                context,
                icon: Icons.inventory_2_outlined,
                title: 'Mis Productos',
                subtitle: 'Gestiona tu inventario',
                onTap: () {
                  // TODO: Navegar a mis productos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función en desarrollo')),
                  );
                },
              ),
              _buildProfileOption(
                context,
                icon: Icons.add_circle_outline,
                title: 'Añadir Producto',
                subtitle: 'Publica un nuevo producto',
                onTap: () {
                  // TODO: Navegar a añadir producto
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función en desarrollo')),
                  );
                },
              ),
              _buildProfileOption(
                context,
                icon: Icons.receipt_long_outlined,
                title: 'Pedidos Recibidos',
                subtitle: 'Ver pedidos de compradores',
                onTap: () {
                  // TODO: Navegar a pedidos recibidos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función en desarrollo')),
                  );
                },
              ),
            ] else ...[
              // Opciones de Comprador
              _buildProfileOption(
                context,
                icon: Icons.map_outlined,
                title: 'Explorar Productos',
                subtitle: 'Encuentra productos cerca de ti',
                onTap: widget.onNavigateToMap ?? () {},
              ),
              _buildProfileOption(
                context,
                icon: Icons.shopping_bag_outlined,
                title: 'Mis Pedidos',
                subtitle: 'Ver historial de compras',
                onTap: () {
                  // TODO: Navegar a mis pedidos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función en desarrollo')),
                  );
                },
              ),
              _buildProfileOption(
                context,
                icon: Icons.favorite_outline,
                title: 'Favoritos',
                subtitle: 'Productos guardados',
                onTap: () {
                  // TODO: Navegar a favoritos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función en desarrollo')),
                  );
                },
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Widget helper para construir opciones del perfil
  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.lightGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryGreen,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySecondary,
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}