import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = false;

  AuthProvider() {
    _auth.authStateChanges().listen((User? u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
