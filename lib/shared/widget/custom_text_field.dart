import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

/// Widget personalizado para campos de texto con estilo consistente
/// 
/// Proporciona un TextFormField con decoración y validación integradas
class CustomTextField extends StatelessWidget {
  /// Controlador del campo de texto
  final TextEditingController controller;
  
  /// Etiqueta del campo
  final String label;
  
  /// Texto de sugerencia (placeholder)
  final String? hint;
  
  /// Ícono al inicio del campo (prefixIcon)
  final IconData? prefixIcon;
  
  /// Ícono al inicio del campo (versión antigua, mantener compatibilidad)
  final IconData? icon;
  
  /// Widget personalizado al final del campo
  final Widget? suffixIcon;
  
  /// Función de validación
  final String? Function(String?)? validator;
  
  /// Tipo de teclado
  final TextInputType? keyboardType;
  
  /// Si el texto debe estar oculto (contraseñas)
  final bool obscureText;
  
  /// Número de líneas
  final int maxLines;
  
  /// Longitud máxima del texto
  final int? maxLength;
  
  /// Formateadores de entrada
  final List<TextInputFormatter>? inputFormatters;
  
  /// Callback cuando el texto cambia
  final void Function(String)? onChanged;
  
  /// Acción del botón de acción del teclado
  final TextInputAction? textInputAction;
  
  /// Callback cuando se envía el formulario (presionar Enter)
  final void Function(String)? onFieldSubmitted;
  
  /// Si el campo está habilitado
  final bool enabled;
  
  /// Si el campo es de solo lectura
  final bool readOnly;
  
  /// Texto del sufijo (ej: "€", "kg")
  final String? suffixText;
  
  /// Texto del prefijo (ej: "+34")
  final String? prefixText;
  
  /// Focus node personalizado
  final FocusNode? focusNode;
  
  /// Si debe autoenfocarse
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.icon, // Mantener para compatibilidad
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.suffixText,
    this.prefixText,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    // Usar prefixIcon si está definido, sino usar icon (compatibilidad)
    final iconToUse = prefixIcon ?? icon;
    
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      style: AppTextStyles.body.copyWith(
        color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary,
        ),
        hintText: hint,
        hintStyle: AppTextStyles.bodySecondary,
        
        // Íconos
        prefixIcon: iconToUse != null
            ? Icon(iconToUse, color: AppColors.textSecondary)
            : null,
        suffixIcon: suffixIcon,
        
        // Texto adicional
        suffixText: suffixText,
        suffixStyle: AppTextStyles.bodySecondary,
        prefixText: prefixText,
        prefixStyle: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w500,
        ),
        
        // Contador de caracteres
        counterText: maxLength != null ? null : '',
        
        // Estilos de los bordes
        filled: true,
        fillColor: enabled ? AppColors.white : AppColors.background,
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 2,
          ),
        ),
        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
        
        // Padding interno
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      
      // Validación
      validator: validator,
      
      // Configuración del teclado
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      
      // Comportamiento
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      
      // Callbacks
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      
      // Corrección automática
      autocorrect: keyboardType != TextInputType.emailAddress &&
          keyboardType != TextInputType.url,
      enableSuggestions: keyboardType != TextInputType.emailAddress &&
          keyboardType != TextInputType.url &&
          !obscureText,
    );
  }
}