import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';

class MenungguSesiPage extends StatelessWidget {
  final String namaMatkul;
  final String sesi;
  final String kelas;

  const MenungguSesiPage({
    super.key,
    required this.namaMatkul,
    required this.sesi,
    this.kelas = "TI-4C",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D47A1), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text("Kembali", style: TextStyle(color: Color(0xFF0D47A1), fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: const CustomBottomNavMahasiswa(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- CARD DETAIL JADWAL BIRU ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0B47A1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned(
                      right: -15, top: -15,
                      child: Stack(
                        children: [
                          Icon(Icons.keyboard_arrow_down, size: 130, color: Colors.white.withOpacity(0.08)),
                          Positioned(top: -35, child: Icon(Icons.keyboard_arrow_down, size: 130, color: Colors.white.withOpacity(0.08))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: Text(kelas, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: Text(sesi, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            namaMatkul, // Dinamis
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text("Rabu, 13 Mei 2024", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),

            // --- ILUSTRASI JAM & TEKS ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF818CF8), width: 3),
                    ),
                    child: const Center(
                      child: Icon(Icons.access_time_rounded, size: 50, color: Color(0xFF6366F1)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Sesi Belum Dimulai",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Presensi dapat dilakukan saat jadwal\nsesi telah dimulai. Silakan kembali lagi\nnanti.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- CARD REKAP ---
                      Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF4FC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFD0E1FD),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "REKAP KEHADIRAN",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5A6A85),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "14/16 ",
                                  style: TextStyle(
                                    color: Color(0xFF1D4ED8),
                                  ),
                                ),
                                TextSpan(
                                  text: "Sesi",
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0B53BF),
                            width: 4.5,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "75%",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}