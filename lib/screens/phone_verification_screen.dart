import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String email;
  final String role;

  const PhoneVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isVerifying = false;
  bool _canResend = false;
  int _resendTimer = 60;
  String? _generatedCode;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendVerificationCode();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _sendVerificationCode() {
    _generatedCode = (100000 + (900000 * (DateTime.now().millisecond / 1000)).round()).toString();
    
    print('📱 Código de verificación enviado: $_generatedCode');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código enviado a +34 ${widget.phoneNumber}'),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendTimer--;
        });
        return _resendTimer > 0;
      }
      return false;
    }).then((_) {
      if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _verifyCode() async {
    String enteredCode = _controllers.map((c) => c.text).join();
    
    if (enteredCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el código completo'),
          backgroundColor: AppColors.accentOrange,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isVerifying = false);

    if (enteredCode == _generatedCode) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Teléfono verificado correctamente'),
            backgroundColor: AppColors.primaryGreen,
            duration: Duration(seconds: 2),
          ),
        );

        print('✅ Usuario registrado:');
        print('   Nombre: ${widget.name}');
        print('   Email: ${widget.email}');
        print('   Teléfono: +34 ${widget.phoneNumber}');
        print('   Rol: ${widget.role}');

        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✗ Código incorrecto, intenta de nuevo'),
          backgroundColor: Colors.red,
        ),
      );
      
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone_android,
                size: 40,
                color: AppColors.primaryGreen,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Verificación de Teléfono",
              style: AppTextStyles.headline.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Hemos enviado un código de 6 dígitos a\n+34 ${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _focusNodes[index].hasFocus 
                          ? AppColors.primaryGreen 
                          : AppColors.border,
                      width: _focusNodes[index].hasFocus ? 2.5 : 2,
                    ),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.headline.copyWith(
                        fontSize: 28,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {});
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        
                        if (index == 5 && value.isNotEmpty) {
                          _verifyCode();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verifyCode,
                style: AppButtonStyles.primary.copyWith(
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        "Verificar",
                        style: AppTextStyles.buttonText,
                      ),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: _canResend
                  ? () {
                      _sendVerificationCode();
                      _startResendTimer();
                    }
                  : null,
              child: Text(
                _canResend
                    ? "Reenviar código"
                    : "Reenviar código en ${_resendTimer}s",
                style: AppTextStyles.body.copyWith(
                  color: _canResend ? AppColors.primaryGreen : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Para pruebas, el código es: $_generatedCode",
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}