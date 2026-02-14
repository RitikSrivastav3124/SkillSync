import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillsync/providers/auth_providers.dart';
import 'package:skillsync/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SkillSync',

        ///  Global Responsive Builder
        builder: (context, child) {
          final screenWidth = MediaQuery.of(context).size.width;

          // Tablet / Desktop font scaling
          double textScale = 1.0;
          if (screenWidth >= 900) {
            textScale = 1.15;
          } else if (screenWidth >= 600) {
            textScale = 1.08;
          }

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
            child: child!,
          );
        },

        theme: ThemeData(
          useMaterial3: true,

          ///  Professional Soft Palette
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3F72AF),
            brightness: Brightness.light,
          ),

          scaffoldBackgroundColor: const Color(0xFFF9F9F9),

          ///  Typography
          textTheme: GoogleFonts.poppinsTextTheme(),

          ///  Card Theme
          cardTheme: CardThemeData(
            elevation: 3,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          ///  Buttons
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          ///  Inputs
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF3F72AF),
                width: 1.5,
              ),
            ),
          ),

          ///  AppBar
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            centerTitle: false,
          ),
        ),

        home: const SplashScreen(),
      ),
    );
  }
}
