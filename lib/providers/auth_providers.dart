import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillsync/services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  bool isLoading = false;

  AuthProvider() {
    user = _authService.currentUser;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      user = await _authService.login(email, password);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      user = await _authService.signUp(email, password);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    notifyListeners();
  }
}
