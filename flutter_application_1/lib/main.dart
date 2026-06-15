import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth/splash_screen.dart'; // Pastikan import splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi SIMPADU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // UBAH BAGIAN INI MENJADI SPLASH SCREEN
      home: const SplashScreen(), 
    );
  }
}