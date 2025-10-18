import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Constructor privado para evitar instanciación
  AppConstants._();
  
  // ============================================
  // CONFIGURACIÓN DE API
  // ============================================
  
  /// URL base de la API.
  /// En desarrollo usa localhost, en producción lee del .env
  static String get apiBaseUrl {
    // Intenta leer del .env primero
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    
    // Fallback para desarrollo local
    // Para Android emulator usa: 'http://10.0.2.2:3000/api'
    // Para iOS simulator usa: 'http://localhost:3000/api'
    return 'http://localhost:3000/api';
  }
  
  /// Timeout para peticiones HTTP en milisegundos
  static int get apiTimeout {
    final timeout = dotenv.env['API_TIMEOUT'];
    return int.tryParse(timeout ?? '') ?? 30000; // 30 segundos por defecto
  }
  
  // ============================================
  // INFORMACIÓN DE LA APP
  // ============================================
  
  static const String appName = 'Rural Roots';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Productos frescos directamente del campo a tu mesa';
  
  // ============================================
  // CONFIGURACIÓN DE VALIDACIÓN
  // ============================================
  
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int phoneNumberLength = 9; // Longitud para España
  static const int verificationCodeLength = 6;
  
  // ============================================
  // CONFIGURACIÓN DE MAPA
  // ============================================
  
  static const double defaultLatitude = 42.4627; // Logroño, La Rioja
  static const double defaultLongitude = -2.4451;
  static const double defaultZoom = 13.0;
  static const double maxSearchRadiusKm = 50.0;
  
  // ============================================
  // CONFIGURACIÓN DE TIMEOUTS
  // ============================================
  
  static const int resendCodeTimeout = 60; // segundos
  static const int splashScreenDuration = 3; // segundos
  
  // ============================================
  // CLAVES DE ALMACENAMIENTO LOCAL
  // ============================================
  
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  
  // ============================================
  // LÍMITES Y CONFIGURACIÓN
  // ============================================
  
  static const int maxProductsPerPage = 20;
  static const int maxUploadImageSizeMB = 5;
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
}