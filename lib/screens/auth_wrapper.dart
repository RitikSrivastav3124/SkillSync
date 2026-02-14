import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/providers/auth_providers.dart';
import 'package:skillsync/screens/home_screen.dart';
import 'package:skillsync/screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user != null) {
      return HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
