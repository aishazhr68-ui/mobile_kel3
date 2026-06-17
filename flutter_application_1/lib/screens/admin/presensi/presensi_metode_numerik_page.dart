import 'package:flutter/material.dart';
import 'presensi_detailmahasiswa_page.dart'; 
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import '../../../services/admin/presensi_service.dart';

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
  String sortBy = "NIM"; // Default sorting
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
      if (mounted) setState(() => isLoading = false);
      debugPrint("Error load rekap mahasiswa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Logika Sorting Data
    List sortedStudents = List.from(students);
    if (sortBy == "NIM") {
      sortedStudents.sort((a, b) => (a["nim"] ?? "").toString().compareTo((b["nim"] ?? "").toString()));
    } else {
      sortedStudents.sort((a, b) => (a["nama"] ?? "").toString().compareTo((b["nama"] ?? "").toString()));
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
        title: const Text("Kembali", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 15)),
      ),
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text("Presensi Matakuliah\n${widget.namaMk}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), height: 1.3)),
                const SizedBox(height: 6),
                const Text("Kelola Presensi/Kehadiran Mahasiswa", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                const SizedBox(height: 24),

                // Header Daftar & Sorting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Daftar Mahasiswa ${widget.namaKelas}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: sortBy,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                          style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                          items: ["NIM", "Nama"].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                          onChanged: (val) => setState(() => sortBy = val!),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔥 LIST MAHASISWA
                if (sortedStudents.isEmpty)
                  const Padding(padding: EdgeInsets.all(20), child: Center(child: Text("Data tidak tersedia")))
                else
                  ...sortedStudents.map((s) {
                    String nim = (s["nim"] ?? s["NIM"] ?? "-").toString();
                    String nama = (s["nama"] ?? s["NAMA"] ?? s["nama_mahasiswa"] ?? "Tanpa Nama").toString();
                    int hadir = int.tryParse((s["hadir"] ?? "0").toString()) ?? 0;
                    int total = int.tryParse((s["total"] ?? "16").toString()) ?? 16;
                    double persentase = total > 0 ? (hadir / total) * 100 : 0;

                    return _buildStudentCard(nim, nama, hadir, total, persentase.toInt());
                  }),
                const SizedBox(height: 100),
              ],
            ),
      ),
    );
  }

  Widget _buildStudentCard(String nim, String nama, int hadir, int totalSesi, int persentase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PresensiDetailMahasiswaPage())),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(nim, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700, fontSize: 11)),
                  const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF2563EB), size: 18),
                ],
              ),
              const SizedBox(height: 6),
              Text(nama, style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("kehadiran : $hadir dari $totalSesi sesi", style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                  Text("$persentase%", style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w700, fontSize: 10)),
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