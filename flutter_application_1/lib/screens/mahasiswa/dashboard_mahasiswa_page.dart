import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/krs/krs_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/presensi/presensi_matakuliah_mahasiswa_page.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart'; 
import 'package:flutter_application_1/models/mahasiswa/dashboard_mahasiswa_model.dart';
import 'package:flutter_application_1/services/mahasiswa/dashboard_mahasiswa_service.dart';
import 'package:flutter_application_1/screens/mahasiswa/presensi/presensi_mahasiswa_page.dart'; 
import 'package:flutter_application_1/screens/mahasiswa/jadwal/jadwal_detail_mahasiswa_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/penilaian/penilaian_matakuliah_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/krs/krs_mahasiswa_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/khs/khs_mahasiswa_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/status%20semester/status_semester_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/tagihan/tagihan_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/presensi/menunggu_sesi_page.dart';
import 'package:flutter_application_1/screens/mahasiswa/data%20mahasiswa/data_mahasiswa_page.dart';

class DashboardMahasiswaPage extends StatefulWidget {
  const DashboardMahasiswaPage({super.key});

  @override
  State<DashboardMahasiswaPage> createState() => _DashboardMahasiswaPageState();
}

class _DashboardMahasiswaPageState extends State<DashboardMahasiswaPage> {
  bool isLoading = true;
  DashboardMahasiswaModel? dashboardData;
  final DashboardMahasiswaService _service = DashboardMahasiswaService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getDashboardData();
      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Gagal memuat data dashboard: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(backgroundColor: Color(0xFFF8FAFC), body: Center(child: CircularProgressIndicator()));
    }

    final student = dashboardData!.studentInfo;

    return Scaffold(
        bottomNavigationBar: const CustomBottomNavMahasiswa(
        currentIndex: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 1. HEADER BIRU
            Container(
              width: double.infinity,
              height: 230,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0), 
              decoration: const BoxDecoration(color: Color(0xFF1565C0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 50,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.person, color: Color(0xFFB0B0B0), size: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Aufa Qonita Salsabila", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text("Mahasiswa - ${student.prodi}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        // --- TAMBAHKAN KODE INI ---
                      const SizedBox(height: 4),
                      const Text(
                        "Tahun Akademik 2025/2026", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 12, 
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2
                        )
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 2. CARD PUTIH BESAR
            Container(
              margin: const EdgeInsets.only(top: 120),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- CARD PUTIH KECIL (WADAH JADWAL) ---
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Jadwal Hari Ini", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                SizedBox(height: 2),
                                Text("Rabu, 20 Mei", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                              ],
                            ),
                          ], 
                        ), 

                        const SizedBox(height: 20),

                        // List Jadwal
                        ...dashboardData!.jadwalHariIni.asMap().entries.map((entry) {
                          var jadwal = entry.value;
                          bool isSesiDimulaiSimulated = jadwal.namaMatkul == "Pemrograman Web";

                          return _buildJadwalCard(
                            context,
                            jadwal,
                            isSesiDimulai: isSesiDimulaiSimulated,
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32), 

                  const Text("MyAcademic", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                  const SizedBox(height: 20),
                  
                  // ==========================================
                  // MENU MYACADEMIC
                  // ==========================================
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.8,
                    children: [
                      _buildMenuItem(
                        Icons.event_available,
                        "Jadwal\nKuliah",
                        const Color(0xFFEFF6FF),
                        const Color(0xFF1E88E5),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JadwalDetailMahasiswaPage(
                                namaKelas: student.semesterAktif,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.fact_check,
                        "Presensi",
                        const Color(0xFFF0FDF4),
                        const Color(0xFF43A047),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PresensiMatakuliahMahasiswaPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.fact_check,
                        "KRS",
                        const Color(0xFFFFF7ED),
                        const Color(0xFFFB8C00),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const KrsMhsPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.star,
                        "Penilaian",
                        const Color(0xFFFEFCE8),
                        const Color(0xFFFBC02D),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PenilaianMatakuliahPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.folder,
                        "KHS",
                        const Color(0xFFFAF5FF),
                        const Color(0xFF8E24AA),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const KhsMhsPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.account_balance_wallet,
                        "Tagihan\nKeuangan",
                        const Color(0xFFF0F9FF),
                        const Color(0xFF039BE5),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TagihanPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.school,
                        "Status\nSemester",
                        const Color(0xFFF5F3FF),
                        const Color(0xFF5E35B1),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StatusSemesterPage()),
                          );
                        },
                      ),
                    ],
                  ),

                  // Teks Copyright
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 100),
                ], // PENUTUP KESALAHAN STRUKTUR DI BAGIAN BAWAH
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Color bgColor, Color iconColor, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 54, width: 54,
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label, 
              textAlign: TextAlign.center, 
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569), height: 1.2)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalCard(BuildContext context, JadwalHariIniModel jadwal, {required bool isSesiDimulai}) {
    final subjectName = jadwal.namaMatkul;
    
    final sesiMapping = {
      "Pemrograman Web": "Sesi 15",
      "Administrasi Database": "Sesi 14",
      "Keamanan Jaringan": "Sesi 14",
    };
    final currentSesi = sesiMapping[subjectName] ?? "Sesi unknown";

    final descMapping = {
      "Pemrograman Web": "Mahasiswa mampu...",
      "Administrasi Database": "Pengontrolan basis...",
      "Keamanan Jaringan": "Instalasi firewall...",
    };
    final currentSesiDesc = descMapping[subjectName] ?? "Materi pending...";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSesiDimulai) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(6)),
            child: const Text("Menunggu Sesi dimulai", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8))),
          ),
          const SizedBox(height: 12),
        ],
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(subjectName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)))),
            const SizedBox(width: 8),
            const Text("Offline - Lab. Komputer\nRekayasa 1", textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B))),
          ],
        ),
        const SizedBox(height: 12),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.people_outline, size: 16, color: Color(0xFF64748B)),
                SizedBox(width: 4),
                Text("4C", style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text(jadwal.waktu, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
              ],
            ),
          ],
        ),
        
        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Color(0xFFF1F5F9), thickness: 1)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$currentSesi | $currentSesiDesc", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ElevatedButton(
              onPressed: () {
                if (isSesiDimulai) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PresensiMahasiswaPage(
                        namaMatkul: subjectName,
                        sesi: currentSesi,
                        waktu: jadwal.waktu,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenungguSesiPage(
                        namaMatkul: subjectName,
                        sesi: currentSesi,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0)
              ),
              child: const Text("Lihat Detail", style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 20), 
      ],
    );
  }
}