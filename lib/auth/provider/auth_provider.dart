import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _username = '';
  bool _isSuperuser = false;

  bool get isAuthenticated => _isAuthenticated;
  String get username => _username;
  bool get isSuperuser => _isSuperuser;

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }
  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }
  void setSuperuser(bool value) {
    _isSuperuser = value;
    notifyListeners();
  }

}