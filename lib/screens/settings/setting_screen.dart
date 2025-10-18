// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/services/user_service.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';
import '../../models/user_rol.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  bool _darkMode = false;
  bool _notifications = true;

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Ajustes',
          style: AppTextStyles.subheadline,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            _buildSectionHeader('Cuenta'),
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.person_outline,
                    title: 'Información personal',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.lock_outline,
                    title: 'Privacidad y seguridad',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.payment,
                    title: 'Métodos de pago',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      _userService.isAgricultor ? Icons.agriculture : Icons.shopping_bag,
                      color: AppColors.primaryGreen,
                    ),
                    title: Text('Modo', style: AppTextStyles.body),
                    subtitle: Text(
                      _userService.isAgricultor ? 'Agricultor' : 'Comprador',
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Switch(
                      value: _userService.isAgricultor,
                      onChanged: (value) {
                        _userService.setRole(
                          value ? UserRole.agricultor : UserRole.comprador,
                        );
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
                      activeThumbColor: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Preferencias'),
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                    title: Text('Notificaciones', style: AppTextStyles.body),
                    trailing: Switch(
                      value: _notifications,
                      onChanged: (value) {
                        setState(() {
                          _notifications = value;
                        });
                      },
                      activeThumbColor: AppColors.primaryGreen,
                    ),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_outlined, color: AppColors.textPrimary),
                    title: Text('Modo oscuro', style: AppTextStyles.body),
                    trailing: Switch(
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                      },
                      activeThumbColor: AppColors.primaryGreen,
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.language,
                    title: 'Idioma',
                    subtitle: 'Español',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Soporte'),
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.help_outline,
                    title: 'Centro de ayuda',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.email_outlined,
                    title: 'Contactar soporte',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Cerrar sesión', style: AppTextStyles.subheadline),
                        content: Text(
                          '¿Estás seguro de que quieres cerrar sesión?',
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
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
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
                    side: const WidgetStatePropertyAll(BorderSide(color: Colors.red)),
                    foregroundColor: const WidgetStatePropertyAll(Colors.red),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                'Versión 1.0.0',
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

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: AppTextStyles.body),
      subtitle: subtitle != null ? Text(subtitle, style: AppTextStyles.bodySecondary) : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      color: AppColors.border,
    );
  }
}