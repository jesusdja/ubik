import 'package:flutter/material.dart';
import 'package:ubik/services/sharedprefereces.dart';

enum AuthStatus {
  checking,
  login,
  home,
}

class AuthProvider extends ChangeNotifier {

  AuthStatus authStatus = AuthStatus.checking;

  AuthProvider() {
    isAuthenticated();
  }

  Future isAuthenticated() async {
    bool goToLogin = SharedPrefs.prefs.getBool('ubikLogin') ?? true;
    authStatus = goToLogin ?  AuthStatus.login : AuthStatus.home;
    notifyListeners();
  }
}
