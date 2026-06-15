import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/mahasiswa/dashboard_mahasiswa_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/data mahasiswa/data_mahasiswa_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/profil_mahasiswa_page.dart';

class CustomBottomNavMahasiswa extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavMahasiswa({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: 25,
        ),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                context: context,
                icon: Icons.home_rounded,
                label: "Dashboard",
                selected: currentIndex == 0,
                onTap: () {
                  if (currentIndex != 0) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DashboardMahasiswaPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),

              _navItem(
                context: context,
                icon: Icons.school_outlined,
                label: "Data Mahasiswa",
                selected: currentIndex == 1,
                onTap: () {
                  if (currentIndex != 1) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DataMahasiswaPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),

              _navItem(
                context: context,
                icon: Icons.person_outline,
                label: "Profil",
                selected: currentIndex == 2,
                onTap: () {
                  if (currentIndex != 2) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfilMahasiswaPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: selected
                ? const Color(0xFF1D4ED8)
                : const Color(0xFF737373),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: selected
                  ? const Color(0xFF1D4ED8)
                  : const Color(0xFF737373),
            ),
          ),
        ],
      ),
    );
  }
}