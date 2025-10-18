import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; 
import 'package:rural_roots_demo1/core/constants/app_constants.dart';
import 'package:rural_roots_demo1/services/user_service.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Ajustes',
          style: AppTextStyles.headline.copyWith(
            fontSize: 20,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Sección: Cuenta
            _buildSectionHeader('Cuenta'),
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.person_outline,
                    title: 'Editar perfil',
                    onTap: () {
                      // TODO: Navegar a pantalla de edición de perfil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función en desarrollo')),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.lock_outline,
                    title: 'Cambiar contraseña',
                    onTap: () {
                      // TODO: Navegar a pantalla de cambio de contraseña
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función en desarrollo')),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.payment,
                    title: 'Métodos de pago',
                    onTap: () {
                      // TODO: Navegar a métodos de pago
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función en desarrollo')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sección: Preferencias
            _buildSectionHeader('Preferencias'),
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text('Notificaciones', style: AppTextStyles.body),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeThumbColor: AppColors.primaryGreen,
                    ),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: const Icon(
                      Icons.dark_mode_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text('Modo oscuro', style: AppTextStyles.body),
                    trailing: Switch(
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                        // TODO: Implementar cambio de tema
                      },
                      activeThumbColor: AppColors.primaryGreen,
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.language,
                    title: 'Idioma',
                    subtitle: 'Español',
                    onTap: () {
                      // TODO: Mostrar selector de idioma
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función en desarrollo')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sección: Soporte
            _buildSectionHeader('Soporte'),
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.help_outline,
                    title: 'Centro de ayuda',
                    onTap: () {
                      // TODO: Abrir centro de ayuda
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función en desarrollo')),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.email_outlined,
                    title: 'Contactar soporte',
                    onTap: () {
                      // TODO: Abrir email o chat de soporte
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función en desarrollo')),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Política de privacidad',
                    onTap: () {
                      // TODO: Mostrar política de privacidad
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función en desarrollo')),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.description_outlined,
                    title: 'Términos y condiciones',
                    onTap: () {
                      // TODO: Mostrar términos y condiciones
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función en desarrollo')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botón de cerrar sesión
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    'Cerrar sesión',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: AppButtonStyles.secondary.copyWith(
                    side: const WidgetStatePropertyAll(
                      BorderSide(color: Colors.red),
                    ),
                    foregroundColor: const WidgetStatePropertyAll(Colors.red),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Versión de la app
            Center(
              child: Text(
                'Versión ${AppConstants.appVersion}',
                style: AppTextStyles.bodySecondary.copyWith(
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Muestra un diálogo de confirmación para cerrar sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Cerrar sesión', style: AppTextStyles.subheadline),
        content: Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Cerrar el diálogo
              Navigator.pop(dialogContext);
              
              // Limpiar el estado del usuario
              context.read<UserService>().logout();
              
              
              context.go('/login');
            },
            child: Text(
              'Cerrar sesión',
              style: AppTextStyles.body.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el encabezado de una sección
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: AppTextStyles.bodySecondary.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Construye un item de configuración
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: AppTextStyles.body),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.bodySecondary)
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  /// Construye un divider entre items
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
      indent: 56,
    );
  }
}