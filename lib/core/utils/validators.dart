// lib/core/utils/validators.dart

import 'package:rural_roots_demo1/core/constants/app_constants.dart';

/// Clase utilitaria que contiene métodos de validación para formularios
/// 
/// Todos los métodos retornan:
/// - `null` si la validación es exitosa
/// - `String` con mensaje de error si falla la validación
class Validators {
  // Constructor privado para evitar instanciación
  Validators._();

  // ============================================
  // VALIDACIONES DE AUTENTICACIÓN
  // ============================================

  /// Valida un email
  /// 
  /// Verifica que:
  /// - No esté vacío
  /// - Tenga formato válido (example@domain.com)
  /// 
  /// Uso:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.validateEmail,
  /// )
  /// ```
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu correo electrónico';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Correo electrónico inválido';
    }

    return null;
  }

  /// Valida una contraseña
  /// 
  /// Verifica que:
  /// - No esté vacía
  /// - Tenga mínimo la longitud configurada en AppConstants
  /// 
  /// Uso:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.validatePassword,
  /// )
  /// ```
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'La contraseña debe tener al menos ${AppConstants.minPasswordLength} caracteres';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'La contraseña no puede exceder ${AppConstants.maxPasswordLength} caracteres';
    }

    return null;
  }

  /// Valida una contraseña con requisitos estrictos
  /// 
  /// Verifica que:
  /// - Cumpla con validatePassword
  /// - Tenga al menos una mayúscula
  /// - Tenga al menos una minúscula
  /// - Tenga al menos un número
  /// 
  /// Uso para registros o cambios de contraseña:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.validateStrongPassword,
  /// )
  /// ```
  static String? validateStrongPassword(String? value) {
    // Primero ejecutar validación básica
    final basicValidation = validatePassword(value);
    if (basicValidation != null) {
      return basicValidation;
    }

    // Verificar que tenga al menos una mayúscula
    if (!RegExp(r'[A-Z]').hasMatch(value!)) {
      return 'Debe contener al menos una mayúscula';
    }

    // Verificar que tenga al menos una minúscula
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Debe contener al menos una minúscula';
    }

    // Verificar que tenga al menos un número
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un número';
    }

    return null;
  }

  /// Valida que dos contraseñas coincidan
  /// 
  /// Uso:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => Validators.validatePasswordMatch(
  ///     value,
  ///     _passwordController.text,
  ///   ),
  /// )
  /// ```
  static String? validatePasswordMatch(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }

    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  // ============================================
  // VALIDACIONES DE DATOS PERSONALES
  // ============================================

  /// Valida un nombre completo
  /// 
  /// Verifica que:
  /// - No esté vacío
  /// - Tenga al menos 2 caracteres
  /// - Solo contenga letras y espacios
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu nombre';
    }

    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    // Permitir letras (incluidas acentuadas), espacios, guiones y apóstrofes
    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s'-]+$").hasMatch(value.trim())) {
      return 'El nombre solo puede contener letras';
    }

    return null;
  }

  /// Valida un número de teléfono español
  /// 
  /// Verifica que:
  /// - No esté vacío
  /// - Tenga exactamente 9 dígitos
  /// - Solo contenga números
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu teléfono';
    }

    // Remover espacios y guiones
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Solo se permiten números';
    }

    if (cleaned.length != AppConstants.phoneNumberLength) {
      return 'El teléfono debe tener ${AppConstants.phoneNumberLength} dígitos';
    }

    // Verificar que comience con 6, 7, 8 o 9 (números móviles españoles)
    if (!RegExp(r'^[6-9]').hasMatch(cleaned)) {
      return 'Número de teléfono inválido';
    }

    return null;
  }

  /// Valida una dirección
  /// 
  /// Verifica que:
  /// - No esté vacía
  /// - Tenga al menos 5 caracteres
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu dirección';
    }

    if (value.trim().length < 5) {
      return 'La dirección debe tener al menos 5 caracteres';
    }

    return null;
  }

  /// Valida un código postal español
  /// 
  /// Verifica que:
  /// - No esté vacío
  /// - Tenga exactamente 5 dígitos
  static String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el código postal';
    }

    if (!RegExp(r'^[0-9]{5}$').hasMatch(value)) {
      return 'Código postal inválido (5 dígitos)';
    }

    // Verificar que esté en el rango válido (01000 - 52999)
    final code = int.tryParse(value);
    if (code == null || code < 1000 || code > 52999) {
      return 'Código postal fuera de rango';
    }

    return null;
  }

  // ============================================
  // VALIDACIONES DE PRODUCTOS
  // ============================================

  /// Valida el nombre de un producto
  /// 
  /// Verifica que:
  /// - No esté vacío
  /// - Tenga al menos 3 caracteres
  /// - No exceda 100 caracteres
  static String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa el nombre del producto';
    }

    if (value.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }

    if (value.trim().length > 100) {
      return 'El nombre no puede exceder 100 caracteres';
    }

    return null;
  }

  /// Valida una descripción
  /// 
  /// Verifica que:
  /// - No esté vacía (opcional)
  /// - No exceda el límite de caracteres
  static String? validateDescription(String? value, {bool required = false}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Por favor ingresa una descripción';
    }

    if (value != null && value.trim().length > 500) {
      return 'La descripción no puede exceder 500 caracteres';
    }

    return null;
  }

  /// Valida un precio
  /// 
  /// Verifica que:
  /// - No esté vacío
  /// - Sea un número válido
  /// - Sea mayor que 0
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa el precio';
    }

    // Permitir coma o punto como separador decimal
    final cleaned = value.replaceAll(',', '.');
    final price = double.tryParse(cleaned);

    if (price == null) {
      return 'Precio inválido';
    }

    if (price <= 0) {
      return 'El precio debe ser mayor que 0';
    }

    if (price > 10000) {
      return 'El precio parece demasiado alto';
    }

    return null;
  }

  /// Valida una cantidad o stock
  /// 
  /// Verifica que:
  /// - No esté vacío
  /// - Sea un número entero válido
  /// - Sea mayor o igual a 0
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa la cantidad';
    }

    final quantity = int.tryParse(value);

    if (quantity == null) {
      return 'Cantidad inválida';
    }

    if (quantity < 0) {
      return 'La cantidad no puede ser negativa';
    }

    return null;
  }

  /// Valida un stock de producto
  /// 
  /// Similar a validateQuantity pero con límites más específicos
  static String? validateStock(String? value) {
    final basicValidation = validateQuantity(value);
    if (basicValidation != null) {
      return basicValidation;
    }

    final stock = int.parse(value!);

    if (stock == 0) {
      return 'El stock debe ser mayor que 0';
    }

    if (stock > 10000) {
      return 'El stock parece demasiado alto';
    }

    return null;
  }

  // ============================================
  // VALIDACIONES GENERALES
  // ============================================

  /// Valida que un campo no esté vacío
  /// 
  /// Uso genérico:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => Validators.required(value, 'Este campo'),
  /// )
  /// ```
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Valida la longitud mínima de un texto
  static String? minLength(String? value, int min, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }

    if (value.length < min) {
      return '$fieldName debe tener al menos $min caracteres';
    }

    return null;
  }

  /// Valida la longitud máxima de un texto
  static String? maxLength(String? value, int max, String fieldName) {
    if (value != null && value.length > max) {
      return '$fieldName no puede exceder $max caracteres';
    }

    return null;
  }

  /// Valida un rango numérico
  static String? numberRange(
    String? value,
    double min,
    double max,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    final number = double.tryParse(value.replaceAll(',', '.'));

    if (number == null) {
      return '$fieldName debe ser un número válido';
    }

    if (number < min || number > max) {
      return '$fieldName debe estar entre $min y $max';
    }

    return null;
  }

  /// Valida una URL
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa una URL';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'URL inválida';
    }

    return null;
  }

  /// Valida un código de verificación numérico
  /// 
  /// Verifica que:
  /// - Tenga la longitud esperada (por defecto 6)
  /// - Solo contenga números
  static String? validateVerificationCode(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el código';
    }

    if (value.length != length) {
      return 'El código debe tener $length dígitos';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'El código solo puede contener números';
    }

    return null;
  }

  // ============================================
  // VALIDACIONES COMBINADAS
  // ============================================

  /// Combina múltiples validaciones
  /// 
  /// Uso:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => Validators.combine([
  ///     () => Validators.required(value, 'Email'),
  ///     () => Validators.validateEmail(value),
  ///   ]),
  /// )
  /// ```
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  // ============================================
  // ALIAS CORTOS (para compatibilidad)
  // ============================================

  /// Alias corto para validateEmail
  static String? email(String? value) => validateEmail(value);

  /// Alias corto para validatePassword
  static String? password(String? value) => validatePassword(value);

  /// Alias corto para validateName
  static String? name(String? value) => validateName(value);

  /// Alias corto para validatePhone
  static String? phone(String? value) => validatePhone(value);
}