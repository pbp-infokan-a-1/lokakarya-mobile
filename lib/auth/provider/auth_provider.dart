import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isSuperuser = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isSuperuser => _isSuperuser;

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  void setSuperuser(bool value) {
    _isSuperuser = value;
    notifyListeners();
  }
}