import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _username = '';

  bool get isAuthenticated => _isAuthenticated;
  String get username => _username;

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }
}
