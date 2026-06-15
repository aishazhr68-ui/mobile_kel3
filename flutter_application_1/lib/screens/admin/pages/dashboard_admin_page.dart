import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/penilaian/penilaian_page.dart';
import 'package:flutter_application_1/screens/admin/data mahasiswa/data_mahasiswa_page.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/models/admin/dashboard_model.dart';
import 'package:flutter_application_1/services/admin/dashboard_service.dart';
import 'package:flutter_application_1/screens/admin/krs/krs_page.dart';
import 'package:flutter_application_1/screens/admin/khs/khs_page.dart';
import 'package:flutter_application_1/screens/admin/jadwal/jadwal_kuliah_page.dart';
import 'package:flutter_application_1/screens/admin/presensi/presensi_matakuliah_page.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() =>
      _DashboardAdminPageState();
}

class _DashboardAdminPageState
    extends State<DashboardAdminPage> {

  DashboardModel? dashboard;

  bool isLoading = true;

  final DashboardService dashboardService =
      DashboardService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

Future<void> loadData() async {
  try {
    final data =
        await dashboardService
            .getDashboardData();

    setState(() {
      dashboard = data;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });

    debugPrint(e.toString());
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      extendBody: true, // 🔥 Biar FAB menyatu dengan lengkungan navbar

      // ================= FLOAT BUTTON =================
      floatingActionButton: const CustomFAB(), // 🔥 Panggil CustomFAB dari file terpisah
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const CustomBottomNavBar(), // 🔥 Panggil CustomBottomNavBar dari file terpisah

      // ================= BODY =================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 10),

              // ===== HEADER =====
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/logo_poliban.png"),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("SIMPADU",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A3490),
                              fontSize: 16)),
                      Text("ADMIN DASHBOARD",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF2563EB),
                    child: Text("AD",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // ===== TITLE =====
              const Text(
                "Dashboard Admin",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4), // Jarak kecil
              const Text(
                "Tahun Akademik 2025/2026",
                style: TextStyle(
                    fontSize: 14, 
                    color: Color(0xFF6B7280), // Warna abu-abu agar serasi
                    fontWeight: FontWeight.w500
                ),
              ),

              const SizedBox(height: 4),

              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Selamat datang, ",
                        style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: "Admin Poliban",
                        style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== STAT CARD =====
              Row(
                children: [
                  Expanded(
                    child:_cardStat(
                    dashboard!.totalMahasiswa.toString(),
                    "Total Mahasiswa",
                      "+8.2%",
                      icon: Icons.school_rounded,
                      color: const Color(0xFF1D4ED8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _cardStat(
                    dashboard!.totalMahasiswaAktif.toString(),
                    "Mahasiswa Aktif",
                    "+6.1%",
                    icon: Icons.groups_rounded,
                    color: const Color(0xFF16A34A),
                  ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _cardStat(
                    dashboard!.totalPengajuanKrs.toString(),
                    "Pengajuan KRS",
                    "+12.5%",
                    icon: Icons.description_rounded,
                    color: const Color(0xFF9333EA),
                  ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()),
                ],
              ),

              const SizedBox(height: 20),

              // ===== JADWAL =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Jadwal Mendatang",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.calendar_today,
                      size: 18, color: Colors.grey),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E40AF),
                      Color(0xFF1D4ED8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10,
                      top: 20,
                      child: Row(
                        children: [
                          Icon(Icons.chevron_left,
                              color: Colors.white.withOpacity(0.2), size: 28),
                          const SizedBox(width: 5),
                          Icon(Icons.chevron_right,
                              color: Colors.white.withOpacity(0.2), size: 28),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Senin, 28 Apr 2024",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Pemrograman Web",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "TI-3A • Lab 201",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(Icons.access_time,
                                size: 14, color: Colors.white),
                            SizedBox(width: 6),
                            Text("08:00 - 10:00",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== MENU =====
              const Text("Layanan Cepat",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),

              const SizedBox(height: 15),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _menu(
                    Icons.group, 
                    "MHS",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DataMahasiswaPage(),
                        ),
                      );
                    },
                  ),
                  _menu(
                    Icons.check,
                    "Presensi",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PresensiMatakuliahPage(
                            idKelas: "1",
                            namaKelas:"TI-4C"
                          ),
                        ),
                      );
                    },
                  ),
                  _menu(
                  Icons.star,
                  "Nilai",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const penilaian_page()),
                    );
                  },
                ),
                  _menu(
                  Icons.calendar_today,
                  "Jadwal",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JadwalKuliahPage(),
                      ),
                    );
                  },
                ),
                 _menu(
                  Icons.description,
                  "KRS",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KrsPage(),
                      ),
                    );
                  },
                ),
                  _menu(
                  Icons.assignment,
                  "KHS",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KhsPage(),
                      ),
                    );
                  },
                ),

                ],
),
                        
              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ===== CARD STAT =====
  Widget _cardStat(String value, String title, String percent,
      {IconData? icon, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color!.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: color,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    percent.replaceAll('+', ''),
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== MENU =====
class _menu extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _menu(this.icon, this.title, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, 
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFE5EDFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: const Color(0xFF2563EB),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF475569),
          ),
        ),
      ],
    ),
  );
}
}