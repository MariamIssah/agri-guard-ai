import 'package:flutter/foundation.dart';
import '../models/user_role.dart';

class UserSession extends ChangeNotifier {
  UserRole? _role;

  UserRole? get role => _role;

  bool get isFarmer => _role == UserRole.farmer;
  bool get isBuyer => _role == UserRole.buyer;

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  void clear() {
    _role = null;
    notifyListeners();
  }
}
