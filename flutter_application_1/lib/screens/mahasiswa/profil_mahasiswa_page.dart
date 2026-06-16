// Lokasi: lib/screens/pages/profil/profil_mahasiswa_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pengaturan_akun_mahasiswa_page.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';
import 'package:flutter_application_1/screens/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/config/api_config.dart';

class ProfilMahasiswaPage extends StatelessWidget {
  const ProfilMahasiswaPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 28),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Yakin Ingin Keluar?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Anda akan keluar dari sistem akademik Poliban.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text("Batal", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                  Expanded(
                      child: ElevatedButton(
                        // 🔥 PERBAIKAN: Ubah menjadi async
                        onPressed: () async {
                          // 1. Tampilkan indikator loading (opsional) atau langsung proses
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('token');

                          // 2. Tembak API Logout untuk mematikan token di server Backend
                          if (token != null) {
                            try {
                              await http.post(
                                Uri.parse(ApiConfig.logoutMahasiswa),
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Accept': 'application/json',
                                  'Authorization': 'Bearer $token',
                                },
                              );
                            } catch (e) {
                              debugPrint("Gagal logout API: $e");
                              // Tetap lanjutkan proses hapus lokal meski API gagal (misal karena tidak ada internet)
                            }
                          }

                          // 3. Hapus sesi lokal di aplikasi
                          await prefs.remove('token');
                          await prefs.remove('role');

                          // 4. Pastikan context masih aktif sebelum pindah halaman
                          if (!context.mounted) return;

                          // 5. Pindah ke halaman Login dan HAPUS semua history halaman (stack)
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                            (route) => false, // false berarti hapus semua tumpukan layar sebelumnya
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text("Ya, Keluar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),               ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const CustomBottomNavMahasiswa(
        currentIndex: 2,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        // ====================================================================
        // PERBAIKAN: Dibungkus SingleChildScrollView agar tidak ada error overflow
        // ====================================================================
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Header Profil (Foto & Nama)
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D6EFD),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text("MH", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Mahasiswa Poliban", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    const Text("Mahasiswa", style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Menu Pengaturan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("PENGATURAN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                    const SizedBox(height: 12),
                    
                    // Tombol Pengaturan Akun
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingsPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
                              child: const Icon(Icons.settings_outlined, color: Color(0xFF1D4ED8), size: 20),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(child: Text("Pengaturan Akun", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
                            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol Keluar
                    InkWell(
                      onTap: () => _showLogoutDialog(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color(0xFFFEF2F2), shape: BoxShape.circle),
                              child: const Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(child: Text("Keluar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
                            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // ====================================================================
              // PERBAIKAN: Spacer dihapus dan diganti SizedBox agar stabil di layar
              // ====================================================================
              const SizedBox(height: 60), 
              
              // Footer Text
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
              
              const SizedBox(height: 120), // Jarak ekstra agar tidak tertutup bottom nav melayang
            ],
          ),
        ),
      ),
    );
  }
}