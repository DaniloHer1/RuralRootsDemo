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

