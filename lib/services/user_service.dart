import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserService extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isFarmer => _currentUser?.isFarmer ?? false;
  bool get isBuyer => _currentUser?.isBuyer ?? false;
  UserRole? get role => _currentUser?.role;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void toggleRole() {
    if (_currentUser == null) return;

    final newRole = _currentUser!.isFarmer ? UserRole.buyer : UserRole.farmer;
    _currentUser = _currentUser!.copyWith(role: newRole);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

// lib/services/auth_service.dart
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../core/errors/failures.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw AuthFailure('Credenciales inválidas');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role.name,
        }),
      );

      if (response.statusCode != 201) {
        throw AuthFailure('Error al registrar usuario');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phoneNumber}),
      );

      if (response.statusCode != 200) {
        throw AuthFailure('Error al enviar código');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  Future<bool> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': phoneNumber,
          'code': code,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw NetworkFailure();
    }
  }
}
