import 'package:flutter/material.dart';
import 'presensi_detailmahasiswa_page.dart'; 
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import '../../../services/admin/presensi_service.dart'; // 🔥 Pastikan path service Anda benar

class PresensiMetodeNumerikPage extends StatefulWidget {
  final String idMk;
  final String namaMk;
  final String namaKelas;

  const PresensiMetodeNumerikPage({
    super.key,
    required this.idMk,
    required this.namaMk,
    required this.namaKelas,
  });

  @override
  State<PresensiMetodeNumerikPage> createState() => _PresensiMetodeNumerikPageState();
}

class _PresensiMetodeNumerikPageState extends State<PresensiMetodeNumerikPage> {
  String sortBy = "NIM";

  bool isLoading = true;
  List<dynamic> students = [];
  final PresensiService presensiService = PresensiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await presensiService.getRekapPresensiMahasiswa(widget.idMk);
      
      if (mounted) {
        setState(() {
          students = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      debugPrint("Error load rekap mahasiswa: $e");
    }
  }

  // 🔥 KESALAHAN SEBELUMNYA: Kurung tutup } sudah ditambahkan di sini
  void _loadMoreData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fitur Load More sedang dikembangkan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F4F6),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: -5,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kembali ke daftar matakuliah",
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),

      // ================= FLOAT BUTTON =================
      floatingActionButton: const CustomFAB(), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const CustomBottomNavBar(),

      // ================= BODY =================
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 🔥 Teks Hardcode diganti menggunakan widget.namaMk agar dinamis
            Text(
              "Presensi Matakuliah\n${widget.namaMk}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), height: 1.3),
            ),
            const SizedBox(height: 6),
            const Text(
              "Kelola Presensi/Kehadiran Mahasiswa",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Header Daftar & Filter Sort
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔥 Teks Hardcode diganti menggunakan widget.namaKelas agar dinamis
                Expanded(
                  child: Text(
                    "Daftar Mahasiswa ${widget.namaKelas}",
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
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
                          value: sortBy,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                          style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                          items: ["NIM", "Nama"].map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => sortBy = val);
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
            const SizedBox(height: 16),

            // ================= LIST MAHASISWA =================
            if (students.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text("Tidak ada data mahasiswa", style: TextStyle(color: Colors.grey))),
              )
            else
              // 🔥 Looping data API dengan parsing tipe data yang aman
              ...students.map((s) {
                String nim = s["nim"]?.toString() ?? "-";
                String nama = s["nama"]?.toString() ?? "-";
                int hadir = int.tryParse(s["hadir"]?.toString() ?? "0") ?? 0;
                int total = int.tryParse(s["total"]?.toString() ?? "16") ?? 16;
                int persen = int.tryParse(s["persen"]?.toString() ?? "0") ?? 0;

                return _buildStudentCard(nim, nama, hadir, total, persen);
              }),

            const SizedBox(height: 10),

            // Button Lainnya
            Center(
              child: InkWell(
                onTap: _loadMoreData, 
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("Lainnya", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 13)),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, color: Color(0xFF2563EB), size: 18),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Footer Copyright
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

  // Widget Card Mahasiswa
  Widget _buildStudentCard(String nim, String nama, int hadir, int totalSesi, int persentase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PresensiDetailMahasiswaPage(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nim,
                    style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                  const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF2563EB), size: 18),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                nama,
                style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "kehadiran : $hadir dari $totalSesi sesi",
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                  ),
                  Text(
                    "$persentase%",
                    style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w700, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: persentase / 100, 
                  minHeight: 4,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}