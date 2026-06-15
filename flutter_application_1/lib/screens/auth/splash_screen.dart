import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/screens/auth/login_page.dart'; // Sesuaikan path-nya
import 'package:flutter_application_1/screens/admin/pages/dashboard_admin_page.dart'; // Sesuaikan path-nya
import 'package:flutter_application_1/screens/mahasiswa/dashboard_mahasiswa_page.dart'; // Sesuaikan path-nya

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // Beri jeda 2 detik agar logo aplikasi terlihat (efek loading)
    await Future.delayed(const Duration(seconds: 2));

    // Buka brankas HP untuk mengecek Token
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? role = prefs.getString('role');

    if (!mounted) return;

    // CEK: Apakah Token ada?
    if (token != null && token.isNotEmpty) {
      // Jika Token ada, cek dia admin atau mahasiswa
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdminPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardMahasiswaPage()),
        );
      }
    } else {
      // Jika Token TIDAK ADA (belum pernah login / sudah logout)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A), // Warna biru Poliban
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tampilkan logo kampus saat aplikasi pertama kali diklik
            Image.asset(
              "assets/logo_poliban.png",
              width: 100,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}