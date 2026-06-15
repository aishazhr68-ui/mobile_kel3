import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart'; 
import 'package:flutter_application_1/models/admin/jadwal_kuliah_model.dart';
import 'package:flutter_application_1/services/admin/jadwal_kuliah_service.dart';
import 'package:flutter_application_1/screens/admin/jadwal/jadwal_detail_page.dart'; // Sesuaikan folder

class JadwalKuliahPage extends StatefulWidget {
  const JadwalKuliahPage({super.key});

  @override
  State<JadwalKuliahPage> createState() => _JadwalKuliahPageState();
}

class _JadwalKuliahPageState extends State<JadwalKuliahPage> {
  bool isLoading = true;
  bool isExpanded = false; // <-- STATE BARU UNTUK TOMBOL LAINNYA
  List<JadwalKelasModel> daftarKelas = [];
  final JadwalKuliahService _service = JadwalKuliahService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getJadwalKelas();
      setState(() {
        daftarKelas = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Gagal memuat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- LOGIKA UNTUK MENAMPILKAN DATA ---
    // Jika isExpanded true, tampilkan semua. Jika false, ambil 4 data pertama saja.
    final displayedData = isExpanded ? daftarKelas : daftarKelas.take(4).toList();
    // Tampilkan tombol "Lainnya" hanya jika total data lebih dari 4
    final showLainnyaButton = daftarKelas.length > 4;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 260,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF1D4ED8)),
            label: const Text(
              "Kembali",
              style: TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  const Text(
                    "Jadwal Kuliah",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Jadwal Kuliah Mahasiswa Per Kelas",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  // FILTER BOX
                  _buildFilterBox(),
                  const SizedBox(height: 24),

                  // SORT BAR
                  _buildSortBar(),
                  const SizedBox(height: 12),

                  // LIST KELAS (Menggunakan displayedData)
                  ...displayedData.map((kelas) => _buildKelasCard(kelas)),

                  // TOMBOL LAINNYA
                  if (showLainnyaButton) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Mengubah state saat diklik
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isExpanded ? "Lebih Sedikit" : "Lainnya", // Teks berubah sesuai state
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, // Ikon berubah
                                size: 16, 
                                color: const Color(0xFF64748B)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),

                  // FOOTER
                  const Center(
                    child: Text(
                      "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  // --- KOMPONEN FILTER BOX ---
  Widget _buildFilterBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Program Studi",
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 6),
                _buildDropdownDummy("Semua Prodi"),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kelas",
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 6),
                _buildDropdownDummy("Semua Kelas"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget dummy dropdown untuk filter box
  Widget _buildDropdownDummy(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Latar abu-abu
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  // --- KOMPONEN SORT BAR ---
  Widget _buildSortBar() {
    return Row(
      children: [
        const Text(
          "Daftar Kelas",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
        ),
        const Spacer(),
        const Text(
          "Sort\nby:",
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), height: 1.2),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Row(
            children: [
              Text("ID/Kelas", style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Icon(Icons.sort, size: 14, color: Color(0xFF94A3B8)),
        )
      ],
    );
  }

  // --- KOMPONEN KARTU KELAS ---
  Widget _buildKelasCard(JadwalKelasModel kelas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (ID Kelas & Jumlah Mahasiswa)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  kelas.idKelas,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.group_outlined, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text(
                    "${kelas.jumlahMahasiswa} Mahasiswa",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Info Kelas & Prodi
          Text(
            kelas.namaKelas,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Text(
            kelas.programStudi,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1F5F9), thickness: 1, height: 1),
          ),
          
          // Tombol Lihat Detail
         // Tombol Lihat Detail
       Align(
         alignment: Alignment.centerRight,
         child: InkWell(
           onTap: () {
             // Navigasi ke halaman detail dengan melempar nama kelas
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => JadwalDetailPage(namaKelas: kelas.namaKelas),
               ),
             );
           },
           child: const Row(
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(
                 "Lihat Detail",
                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8)),
               ),
               SizedBox(width: 2),
               Icon(Icons.chevron_right, size: 16, color: Color(0xFF1D4ED8)),
             ],
           ),
         ),
       )       ],
      ),
    );
  }
}