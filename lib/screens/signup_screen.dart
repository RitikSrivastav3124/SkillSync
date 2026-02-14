import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/providers/auth_providers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Account",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = 450;

            if (constraints.maxWidth >= 900) {
              maxWidth = 520; // Desktop
            } else if (constraints.maxWidth >= 600) {
              maxWidth = 480; // Tablet
            }

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 600 ? 24 : 40,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header
                          Center(
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.person_add_alt_1_rounded,
                                  size: 46,
                                  color: Color(0xFF3F72AF),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Join SkillSync",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Create your account to get started",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 36),

                          /// Email
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Enter your email",
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// Password
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Create a password",
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// Sign Up Button
                          authProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await authProvider.signUp(
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                        Navigator.pop(context);
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(e.toString()),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Create Account",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
