// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/screens/main_screen.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),

            // LOGO SOLAMENTE
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // CARD de inicio de sesión
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.border.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Iniciar Sesión",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de correo
                  TextField(
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
                      labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      hintText: "tu@email.com",
                      hintStyle: AppTextStyles.bodySecondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de contraseña
                  TextField(
                    obscureText: true,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botón de iniciar sesión
                  ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla principal
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    style: AppButtonStyles.primary.copyWith(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    child: Text(
                      "Iniciar Sesión",
                      style: AppTextStyles.buttonText,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Enlace a registro
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          text: "¿No tienes cuenta? ",
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(
                              text: "Regístrate",
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Texto inferior
            Text(
              "Productos frescos directamente del campo a tu mesa",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}