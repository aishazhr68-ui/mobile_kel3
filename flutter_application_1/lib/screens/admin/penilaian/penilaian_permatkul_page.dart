import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/penilaian/detail_penilaian_permatkul_page.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';


class penilaian_permatkul_page extends StatefulWidget {
  const penilaian_permatkul_page({super.key});

  @override
  State<penilaian_permatkul_page> createState() => _penilaian_permatkul_pageState();
}

class _penilaian_permatkul_pageState extends State<penilaian_permatkul_page> {
  String selectedProdi = "Semua Prodi";
  String selectedKelas = "Semua Kelas";
  String sortById = "ID Matakuliah";
  
  // State untuk mengontrol daftar presensi yang tersembunyi
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: -5,
        leadingWidth: 40,
       leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Color(0xFF2563EB),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
        title: const Text(
          "Kembali ke daftar kelas",
          style: TextStyle(
            color: Color(0xFF2563EB),
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header Text
            const Text(
              "Penilaian Mahasiswa",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
            "Penilaian Mahasiswa Per Matakuliah",
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

            // ================= DAFTAR PRESENSI TABLE =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Table Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Daftar\nMatakuliah TI-4C",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, height: 1.2),
                        ),
                        Row(
                          children: [
                            const Text("Sort\nby: ", style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.2)),
                            const SizedBox(width: 6),
                            Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: sortById,
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "ID Matakuliah",
                                      child: Text("ID Matakuliah"),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setState(() => sortById = val);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.filter_list, size: 18, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: const Color(0xFFEFF6FF),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: const [

                        Expanded(
                          flex: 2,
                          child: Text(
                            "ID",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 4,
                          child: Text(
                            "MATAKULIAH",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Text(
                            "DOSEN",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  // Table Rows Data (Default)
                  _buildMatkulRow(
                    "C0320401",
                    "Administrasi Database",
                    "Rahimi Fitri, S.Kom., M.Kom",
                  ),

                  _buildMatkulRow(
                    "C0320402",
                    "Keamanan Jaringan",
                    "Dr. Kun Nursyaiful PP, S.T., M.Kom",
                  ),

                  _buildMatkulRow(
                    "C0320403",
                    "Metode Numerik",
                    "Nitami Lestari Putri, S.Kom., M.Kom",
                  ),

                  _buildMatkulRow(
                    "C0320404",
                    "Pemrograman Perangkat Bergerak",
                    "Arif Noor Aisykin, S.T., M.T",
                  ),

                  _buildMatkulRow(
                    "C0320405",
                    "Pemrograman Web",
                    "Agus Setiyo B.N, S.T., M.Kom",
                  ),

                  _buildMatkulRow(
                    "C0320406",
                    "Perancangan Perangkat Lunak Berbasis Objek",
                    "Abdul Kadir, PhD",
                  ),

                  _buildMatkulRow(
                    "C0320407",
                    "Kecerdasan Buatan",
                    "Yeonie Indrasary",
                  ),
                                  ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= FOOTER COPYRIGHT =================
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
    );
  }

  // ================= HELPER WIDGETS =================

  // Widget untuk Card Statistik 
  Widget _buildStatCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required Widget topWidget,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              topWidget,
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Widget untuk persentase naik/turun di dalam Stat Card
  Widget _buildTrendPill(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, size: 10, color: textColor),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }

  // Widget untuk Filter Dropdown (Prodi & Kelas)
  Widget _buildFilterDropdown(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        const SizedBox(height: 6),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
              style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500),
              items: items.map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
              onChanged: (val) {}, // handle state change here
            ),
          ),
        ),
      ],
    );
  }

Widget _buildMatkulRow(
  String id,
  String matkul,
  String dosen,
) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPenilaianPerMatkulPage(
            namaMatkul: matkul,
            kelas: "TI-4C",
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            flex: 2,
            child: Text(
              id,
              style: const TextStyle(
                color: Color(0xFF0A3490),
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Text(
              matkul,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF334155),
                height: 1.3,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              dosen,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF334155),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
