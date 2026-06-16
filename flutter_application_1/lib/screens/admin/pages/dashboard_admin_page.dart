// Lokasi: lib/screens/admin/dashboard/dashboard_admin_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/penilaian/penilaian_page.dart';
import 'package:flutter_application_1/screens/admin/data mahasiswa/data_mahasiswa_page.dart';
import 'package:flutter_application_1/screens/admin/presensi/presensi_page.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/screens/admin/krs/krs_page.dart';
import 'package:flutter_application_1/screens/admin/khs/khs_page.dart';
import 'package:flutter_application_1/screens/admin/jadwal/jadwal_kuliah_page.dart';

// Import Model & Service
import 'package:flutter_application_1/models/admin/dashboard_model.dart';
import 'package:flutter_application_1/services/admin/dashboard_service.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  DashboardModel? dashboard;
  bool isLoading = true;
  final DashboardAdminService _service = DashboardAdminService();

  @override
  void initState() {
    super.initState();
    _loadData(); 
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getDashboardData();
      if (mounted) {
        setState(() {
          dashboard = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Gagal memuat dashboard: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  
    if (dashboard == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 16),
              const Text("Gagal memuat data dashboard."),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => isLoading = true);
                  _loadData(); 
                },
                child: const Text("Coba Lagi"),
              )
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      extendBody: true, 
      floatingActionButton: const CustomFAB(), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(), 
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
                      Text("SIMPADU", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A3490), fontSize: 16)),
                      Text("ADMIN DASHBOARD", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF2563EB),
                    child: Text("AD", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // ===== TITLE =====
              const Text("Dashboard Admin", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("Tahun Akademik 2025/2026", style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: "Selamat datang, ", style: TextStyle(color: Colors.grey)),
                    TextSpan(text: "Admin Poliban", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
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
                      icon: Icons.school_rounded,
                      color: const Color(0xFF1D4ED8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _cardStat(
                      dashboard!.mahasiswaAktif.toString(),
                      "Mahasiswa Aktif",
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
                      // Data Tagihan UKT (Ganti dari KRS)
                      "Rp ${dashboard!.totalTagihanUkt}",
                      "Tagihan UKT",
                      icon: Icons.account_balance_wallet_rounded,
                      color: const Color(0xFF9333EA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()), 
                ],
              ),

              const SizedBox(height: 20),

              // ===== JADWAL DINAMIS DARI API =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Jadwal Mendatang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),

              // Jika data jadwal kosong, tampilkan kotak kosong. Jika ada, tampilkan jadwal.
              if (dashboard!.jadwalPerkuliahan.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(
                    child: Text("Tidak ada jadwal mendatang hari ini.", style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                SizedBox(
                  height: 155, // Tinggi card jadwal
                  child: PageView.builder(
                    itemCount: dashboard!.jadwalPerkuliahan.length,
                    itemBuilder: (context, index) {
                      final jadwal = dashboard!.jadwalPerkuliahan[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8), // Sedikit jarak antar card jika digeser
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E40AF), Color(0xFF1D4ED8)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            // Ikon panah sebagai petunjuk bisa digeser (jika lebih dari 1)
                            if (dashboard!.jadwalPerkuliahan.length > 1)
                              Positioned(
                                right: 0, top: 30,
                                child: Row(
                                  children: [
                                    Icon(Icons.chevron_left, color: Colors.white.withOpacity(0.3), size: 28),
                                    Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 28),
                                  ],
                                ),
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    jadwal.hariTanggal,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              Text(
                                jadwal.namaMk,
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 1, // Batasi 1 baris
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${jadwal.namaKelas} • ${jadwal.ruang}",
                                style: const TextStyle(color: Colors.white70),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14, color: Colors.white),
                                    const SizedBox(width: 6),
                                    Text("${jadwal.jamMulai} - ${jadwal.jamSelesai}", style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              // ===== MENU LAYANAN =====
              const Text("Layanan Cepat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _menu(Icons.group, "MHS", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DataMahasiswaPage()))),
                  _menu(Icons.check, "Presensi", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PresensiPage()))),
                  _menu(Icons.star, "Nilai", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const penilaian_page()))),
                  _menu(Icons.calendar_today, "Jadwal", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JadwalKuliahPage()))),
                  _menu(Icons.description, "KRS", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KrsPage()))),
                  _menu(Icons.assignment, "KHS", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KhsPage()))),
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

  // ===== CARD STAT (Diubah agar tidak mewajibkan parameter persentase) =====
  Widget _cardStat(String value, String title, {IconData? icon, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color!.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
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
            width: 52, height: 52,
            decoration: BoxDecoration(color: const Color(0xFFE5EDFF), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 24, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
        ],
      ),
    );
  }
}