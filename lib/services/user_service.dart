// lib/services/user_service.dart
import 'package:flutter/foundation.dart';

enum UserRole { agricultor, comprador }

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Datos del usuario
  String _name = "María González";
  UserRole _role = UserRole.agricultor;
  String? _email;
  String? _phone;
  String? _address;

  // Getters
  String get name => _name;
  UserRole get role => _role;
  bool get isAgricultor => _role == UserRole.agricultor;
  bool get isComprador => _role == UserRole.comprador;
  String? get email => _email;
  String? get phone => _phone;
  String? get address => _address;

  // Setters con notificación
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
    print('👤 Rol cambiado a: ${role == UserRole.agricultor ? "Agricultor" : "Comprador"}');
  }

  void toggleRole() {
    _role = _role == UserRole.agricultor 
        ? UserRole.comprador 
        : UserRole.agricultor;
    notifyListeners();
  }

  void setEmail(String? email) {
    _email = email;
    notifyListeners();
  }

  void setPhone(String? phone) {
    _phone = phone;
    notifyListeners();
  }

  void setAddress(String? address) {
    _address = address;
    notifyListeners();
  }

  // Método para actualizar todo el perfil
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (address != null) _address = address;
    notifyListeners();
  }

  // Método para resetear (cerrar sesión)
  void logout() {
    _name = "";
    _role = UserRole.comprador;
    _email = null;
    _phone = null;
    _address = null;
    notifyListeners();
  }
}