import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/pages/dashboard_admin_page.dart';
import 'package:flutter_application_1/screens/admin/data%20mahasiswa/data_mahasiswa_page.dart';
import 'package:flutter_application_1/screens/admin/pages/profil_admin_page.dart';

// ==========================================
// WIDGET: BOTTOM NAVIGATION BAR
// ==========================================
class CustomBottomNavBar extends StatelessWidget {
  // 🔥 Tambahkan parameter ini untuk melacak halaman aktif
  final int selectedIndex; 

  // Default nilainya 0 (Home)
  const CustomBottomNavBar({super.key, this.selectedIndex = 0}); 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            // ===== HOME =====
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: InkWell(
                onTap: () {
                  // Mencegah push layar berkali-kali jika sudah di Home
                  if (selectedIndex != 0) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardAdminPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.grid_view_rounded,
                      // 🔥 Warna berubah dinamis sesuai index
                      color: selectedIndex == 0 ? const Color(0xFF0A3490) : const Color(0xFF6B7280),
                      size: 30,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 13,
                        // 🔥 Warna dan ketebalan huruf berubah dinamis
                        color: selectedIndex == 0 ? const Color(0xFF0A3490) : const Color(0xFF6B7280),
                        fontWeight: selectedIndex == 0 ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 70),

            // ===== PROFIL =====
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () {
                  // Mencegah push layar berkali-kali jika sudah di Profil
                  if (selectedIndex != 1) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileAdminPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      // 🔥 Mengubah icon menjadi solid jika aktif (opsional agar mirip desain)
                      selectedIndex == 1 ? Icons.person : Icons.person_outline_rounded, 
                      color: selectedIndex == 1 ? const Color(0xFF0A3490) : const Color(0xFF6B7280),
                      size: 30,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Profil",
                      style: TextStyle(
                        fontSize: 13,
                        color: selectedIndex == 1 ? const Color(0xFF0A3490) : const Color(0xFF6B7280),
                        fontWeight: selectedIndex == 1 ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET: FLOATING ACTION BUTTON (FAB)
// ==========================================
class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 12),
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFF0A3490),
              elevation: 8,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(context) => const DataMahasiswaPage(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                size: 33,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}