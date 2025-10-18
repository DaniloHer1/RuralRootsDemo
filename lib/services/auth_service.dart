// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/user_rol.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Stream para escuchar cambios de autenticación
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges().map((fbUser) {
      if (fbUser == null) {
        _currentUser = null;
        return null;
      }
      // Aquí cargarías los datos completos del usuario desde tu DB
      return _currentUser;
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Cargar datos del usuario desde tu base de datos
        await _loadUserData(credential.user!.uid);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error en signIn: $e');
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Crear usuario en tu base de datos
        _currentUser = User(
          id: credential.user!.uid,
          name: name,
          email: email,
          phone: phone,
          role: role,
          createdAt: DateTime.now(),
        );
        
        // Guardar en base de datos
        await _saveUserToDatabase(_currentUser!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error en signUp: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    // Implementar carga desde DatabaseService
    // _currentUser = await DatabaseService().getUser(uid);
  }

  Future<void> _saveUserToDatabase(User user) async {
    // Implementar guardado en DatabaseService
    // await DatabaseService().saveUser(user);
  }
}