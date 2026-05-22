import 'package:flutter/foundation.dart';
import '../models/auth_user.dart';

class AuthNotifier extends ChangeNotifier {
  AuthUser? _user;

  AuthUser? get user => _user;
  bool get isAuthenticated => _user != null;

  void login(AuthUser user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
