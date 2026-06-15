// Lokasi: lib/screens/krs_kelas_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart'; 
import 'package:flutter_application_1/models/admin/krs_kelas_model.dart';
import 'package:flutter_application_1/services/admin/krs_kelas_service.dart';

// PASTIKAN IMPORT HALAMAN DETAIL KRS MAHASISWA-NYA DISINI
import 'package:flutter_application_1/screens/admin/krs/detail_krs_page.dart'; // Sesuaikan jika namanya berbeda

class KrsKelasPage extends StatefulWidget {
  final String namaKelas; 

  const KrsKelasPage({
    super.key, 
    this.namaKelas = "AK-2A", 
  });

  @override
  State<KrsKelasPage> createState() => _KrsKelasPageState();
}

class _KrsKelasPageState extends State<KrsKelasPage> {
  bool isExpanded = false;
  bool isLoading = true; // Tambahkan state loading
  List<StudentKrs> dataMahasiswa = []; // Kosongkan data awal
  
  // Panggil service
  final KrsKelasService _krsDetailService = KrsKelasService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk mengambil data dari service
  Future<void> _loadData() async {
    try {
      final data = await _krsDetailService.gettKrsKelas(widget.namaKelas);
      setState(() {
        dataMahasiswa = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Gagal memuat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading saat data sedang diambil
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final displayedData = isExpanded ? dataMahasiswa : dataMahasiswa.take(4).toList();
    final showLainnyaButton = dataMahasiswa.length > 4;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
      
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leadingWidth: 250,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Color(0xFF1D4ED8),
            ),
            label: const Text(
              "Kembali Ke daftar kelas",
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
          child: Container(
            color: const Color(0xFFE2E8F0), 
            height: 1.0,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "KRS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Kartu Rencana Studi",
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20), 
                  ),
                  child: const Row(
                    children: [
                      Text(
                        "Sort by: NIM (A-Z)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF475569)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    size: 20,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0).withOpacity(0.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "DATA MAHASISWA",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "STATUS",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Mapping Data Mahasiswa
            ...displayedData.map((student) => _buildStudentCard(student)),

            // Tombol Lainnya Dikembalikan ke Fungsi Awal
            if (showLainnyaButton)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded; // Mengubah state untuk membuka list
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Lainnya",
                            style: TextStyle(
                              color: Color(0xFF1D4ED8),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isExpanded 
                                ? Icons.keyboard_arrow_up 
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF1D4ED8),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentKrs student) {
    bool isApproved = student.status == "Disetujui" || student.status.toUpperCase() == "DISETUJUI";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.nim,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "SKS : ${student.sks}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isApproved 
                  ? const Color(0xFFDCFCE7) 
                  : const Color(0xFFFFEDD5), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              student.status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isApproved 
                    ? const Color(0xFF16A34A) 
                    : const Color(0xFFEA580C), 
              ),
            ),
          ),

          const SizedBox(width: 12),

          // NAVIGASI IKON MATA DIPINDAHKAN KESINI
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Sesuaikan dengan nama class halaman detail Anda, misal StudentKrsDetailPage
                  builder: (context) => DetailKrsPage(nim: student.nim), 
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0), // Padding untuk memperbesar area klik
              child: Icon(
                Icons.visibility_outlined,
                color: Color(0xFF1D4ED8),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}