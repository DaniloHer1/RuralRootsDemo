import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rural_roots_demo1/core/errors/error_handler.dart';
import 'package:rural_roots_demo1/shared/widget/custom_button.dart';
import 'package:rural_roots_demo1/shared/widget/custom_text_field.dart';
import 'package:rural_roots_demo1/shared/widget/loading_overlay.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/validators.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late final AuthService _authService;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(baseUrl: AppConstants.apiBaseUrl);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Actualizar el estado del usuario
      context.read<UserService>().setUser(user);

      // Navegar a la pantalla principal
      context.go('/main');
      
      // Mostrar mensaje de éxito
      ErrorHandler.showSuccess(context, '¡Bienvenido ${user.name}!');
      
    } on AuthFailure catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } on NetworkFailure catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e, onRetry: _handleLogin);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, const UnknownFailure());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // Logo
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

                  // Formulario
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Iniciar Sesión",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headline.copyWith(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email
                          CustomTextField(
                            controller: _emailController,
                            label: "Correo electrónico",
                            hint: "tu@email.com",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 16),

                          // Password
                          CustomTextField(
                            controller: _passwordController,
                            label: "Contraseña",
                            icon: Icons.lock_outlined,
                            obscureText: _obscurePassword,
                            validator: Validators.password,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Olvidé mi contraseña
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Implementar recuperación de contraseña
                                ErrorHandler.showWarning(
                                  context,
                                  'Función en desarrollo',
                                );
                              },
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: AppTextStyles.bodySecondary.copyWith(
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botón de login
                          CustomButton(
                            text: "Iniciar Sesión",
                            onPressed: _handleLogin,
                            isLoading: _isLoading,
                            expanded: true,
                          ),
                          const SizedBox(height: 16),

                          // Enlace a registro
                          GestureDetector(
                            onTap: () => context.go('/register'),
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
          ),

          // Loading overlay
          if (_isLoading)
            const LoadingOverlay(
              message: 'Iniciando sesión...',
            ),
        ],
      ),
    );
  }
}