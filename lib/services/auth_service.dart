import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../core/errors/failures.dart';
import '../core/constants/app_constants.dart';

/// Servicio de autenticación consolidado
/// Maneja login, registro y verificación de usuarios
/// 
/// Este servicio es un singleton que se puede usar directamente
/// o a través de Provider para reactividad
class AuthService extends ChangeNotifier {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Cliente HTTP
  late final http.Client _client;
  
  // Constructor alternativo para testing o con URL personalizada
  AuthService.withBaseUrl(String baseUrl) : _baseUrl = baseUrl {
    _client = http.Client();
  }

  // URL base de la API
  String _baseUrl = AppConstants.apiBaseUrl;
  String get baseUrl => _baseUrl;

  // Usuario actual (si existe)
  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Inicializa el servicio
  void initialize() {
    _client = http.Client();
  }

  /// Realiza una petición HTTP con timeout y manejo de errores mejorado
  Future<http.Response> _makeRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(
        Duration(milliseconds: AppConstants.apiTimeout),
        onTimeout: () {
          throw TimeoutException(
            'La petición tardó demasiado. Verifica tu conexión.',
          );
        },
      );
    } on SocketException {
      throw NetworkFailure();
    } on TimeoutException {
      throw NetworkFailure();
    } on http.ClientException {
      throw NetworkFailure();
    } on FormatException {
      throw const DatabaseFailure('Formato de respuesta inválido');
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  // ============================================
  // MÉTODOS DE AUTENTICACIÓN
  // ============================================

  /// Inicia sesión con email y contraseña
  /// 
  /// Retorna el usuario autenticado
  /// Lanza [AuthFailure] si las credenciales son incorrectas
  /// Lanza [NetworkFailure] si hay problemas de conexión
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _makeRequest(
        () => _client.post(
          Uri.parse('$_baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
          }),
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['user'] == null) {
          throw const DatabaseFailure('Respuesta del servidor inválida');
        }
        
        _currentUser = User.fromJson(data['user']);
        notifyListeners();
        return _currentUser!;
      } else if (response.statusCode == 401) {
        throw const AuthFailure('Email o contraseña incorrectos');
      } else if (response.statusCode == 404) {
        throw const AuthFailure('Usuario no encontrado');
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure('Error en el servidor. Intenta más tarde');
      } else {
        throw AuthFailure('Error al iniciar sesión: ${response.statusCode}');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Registra un nuevo usuario
  /// 
  /// Lanza [AuthFailure] si el email ya está registrado
  /// Lanza [NetworkFailure] si hay problemas de conexión
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await _makeRequest(
        () => _client.post(
          Uri.parse('$_baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': name,
            'email': email,
            'phone': phone,
            'password': password,
            'role': role.name,
          }),
        ),
      );

      if (response.statusCode == 201) {
        // Registro exitoso
        return;
      } else if (response.statusCode == 409) {
        throw const AuthFailure('Este email ya está registrado');
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        final message = data['message'] ?? 'Datos de registro inválidos';
        throw AuthFailure(message);
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure('Error en el servidor. Intenta más tarde');
      } else {
        throw AuthFailure('Error al registrar: ${response.statusCode}');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Envía un código de verificación al número de teléfono
  Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      final response = await _makeRequest(
        () => _client.post(
          Uri.parse('$_baseUrl/auth/send-code'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'phone': phoneNumber}),
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        throw const AuthFailure('Número de teléfono inválido');
      } else if (response.statusCode == 429) {
        throw const AuthFailure('Demasiados intentos. Espera unos minutos');
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure('Error en el servidor. Intenta más tarde');
      } else {
        throw AuthFailure('Error al enviar código: ${response.statusCode}');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Verifica el código de verificación
  Future<bool> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final response = await _makeRequest(
        () => _client.post(
          Uri.parse('$_baseUrl/auth/verify-code'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'phone': phoneNumber,
            'code': code,
          }),
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return false;
      } else if (response.statusCode == 410) {
        throw const AuthFailure('El código ha expirado. Solicita uno nuevo');
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure('Error en el servidor. Intenta más tarde');
      } else {
        throw AuthFailure('Error al verificar código: ${response.statusCode}');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Cierra la sesión del usuario actual
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  /// Actualiza el usuario actual
  void updateCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Limpia el usuario actual sin notificar
  void clearUser() {
    _currentUser = null;
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
    super.dispose();
  }
}