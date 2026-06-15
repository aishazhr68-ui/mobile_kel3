import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';

class PresensiDetailMahasiswaPage extends StatefulWidget {
  const PresensiDetailMahasiswaPage({super.key});

  @override
  State<PresensiDetailMahasiswaPage> createState() => _PresensiDetailMahasiswaPageState();
}

class _PresensiDetailMahasiswaPageState extends State<PresensiDetailMahasiswaPage> {
  // State untuk melacak apakah tombol "Lihat Selengkapnya" sudah diklik
  bool isExpanded = false;

  // Data dummy riwayat kehadiran
  final List<Map<String, dynamic>> riwayatKehadiran = [
    {"top": "PERTEMUAN 1", "title": "Kontrak Perkuliahan", "date": "12 Feb 2026", "status": "HADIR", "color": const Color(0xFF16A34A)},
    {"top": "PERTEMUAN 2", "title": "Konsep Metode Numerik", "date": "19 Feb 2026", "status": "IZIN", "color": const Color(0xFFF97316)},
    {"top": "PERTEMUAN 3", "title": "Menjelaskan Error/Galat", "date": "26 Feb 2026", "status": "HADIR", "color": const Color(0xFF16A34A)},
    // Data tambahan yang muncul saat diklik "Lihat Selengkapnya"
    {"top": "PERTEMUAN 4", "title": "Akar Persamaan Non-Linear", "date": "05 Mar 2026", "status": "HADIR", "color": const Color(0xFF16A34A)},
    {"top": "PERTEMUAN 5", "title": "Metode Biseksi & Regula Falsi", "date": "12 Mar 2026", "status": "ALFA", "color": const Color(0xFFEF4444)},
  ];

  @override
  Widget build(BuildContext context) {
    // Menentukan berapa data yang ditampilkan (3 jika belum expand, semua jika sudah expand)
    List<Map<String, dynamic>> displayedRiwayat = isExpanded ? riwayatKehadiran : riwayatKehadiran.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: -5,
        leadingWidth: 48,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D4ED8)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kembali ke daftar mahasiswa",
          style: TextStyle(
            color: Color(0xFF1D4ED8),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

       // ================= FLOAT BUTTON =================
      floatingActionButton: const CustomFAB(), // 🔥 Panggil CustomFAB dari file terpisah
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const CustomBottomNavBar(), // 🔥 Panggil CustomBottomNavBar dari file terpisah
    
      // ================= BODY =================
      body: SingleChildScrollView(
        // Padding bawah diperbesar menjadi 140 agar saat scroll mentok, konten benar-benar naik melewati Bottom Nav
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              "Presensi Matakuliah Metode\nNumerik",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Detail Presensi Mahasiswa",
              style: TextStyle(
                color: Color(0xFF475569),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 25),

            // Card Profil Mahasiswa
            _buildStudentInfoCard(),
            const SizedBox(height: 24),

            // Grid Statistik Kehadiran
            Row(
              children: [
                Expanded(
                  child: _buildBlueCard(
                    title: "TOTAL PERTEMUAN",
                    value: "11/16",
                    subtitle: "Pertemuan Terdaftar",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGreyCard(
                    title: "HADIR",
                    value: "10",
                    trend: "+8.2%",
                    subtitle: "Pertemuan",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildGreyCard(
                    title: "IZIN / SAKIT",
                    value: "1",
                    trend: "+8.2%",
                    subtitle: "Pertemuan",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGreyCard(
                    title: "ALFA",
                    value: "0",
                    trend: "+8.2%",
                    subtitle: "Pertemuan",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Detail Matakuliah
            _buildCourseDetailSection(),
            const SizedBox(height: 25),

            // Riwayat Kehadiran
            const Text(
              "Riwayat Kehadiran",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 15),

            // Render list riwayat kehadiran secara dinamis
            ...displayedRiwayat.map((data) => _buildHistoryItem(
              data["top"], 
              data["title"], 
              data["date"], 
              data["status"], 
              data["color"]
            )),

            const SizedBox(height: 10),

            // Tombol Lihat Selengkapnya (Disembunyikan jika sudah expand)
            if (!isExpanded)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                  icon: const Text(
                    "Lihat Selengkapnya",
                    style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600),
                  ),
                  label: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF475569)),
                ),
              ),

            const SizedBox(height: 30),

            // Footer Copyright
            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.4),
              ),
            ),
            
            // RUANG EKSTRA: Menjamin teks copyright tidak tertutup oleh tombol tengah
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= WIDGET HELPER: INFO MAHASISWA =================
  Widget _buildStudentInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 32,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Aufa Qonita Salsabila",
                  style: TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "C030324011",
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "D3 Teknik Informatika",
                        style: TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "TI-4C",
                        style: TextStyle(
                          color: Color(0xFF3730A3),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= WIDGET HELPER: KOTAK BIRU (Total Pertemuan) =================
  Widget _buildBlueCard({required String title, required String value, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0044A9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGET HELPER: KOTAK ABU-ABU (Hadir, Izin, Alfa) =================
  Widget _buildGreyCard({required String title, required String value, required String trend, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  trend,
                  style: const TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGET HELPER: DETAIL MATAKULIAH =================
  Widget _buildCourseDetailSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("MATAKULIAH", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
          const SizedBox(height: 2),
          const Text("Metode Numerik", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1D4ED8))),
          const SizedBox(height: 18),
          _rowDetail("DOSEN", "Nitami Lestari Putri, S. Kom. M. Kom."),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _rowDetail("SKS", "3")),
              Expanded(child: _rowDetail("RUANG", "Lab. ARVR")),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _rowDetail("HARI/TANGGAL", "Kamis, 7 Mei 2026")),
              Expanded(child: _rowDetail("JAM", "08.00 - 10.30")),
            ],
          ),
        ],
      ),
    );
  }

  // ================= WIDGET HELPER: SUB-DETAIL TEXT =================
  Widget _rowDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
      ],
    );
  }

  // ================= WIDGET HELPER: HISTORY ITEM (BORDER DITEBALKAN) =================
  Widget _buildHistoryItem(String top, String title, String date, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(top, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF64748B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Text("$date  •  08.00 - 10.30", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
            ],
          )
        ],
      ),
    );
  }
}