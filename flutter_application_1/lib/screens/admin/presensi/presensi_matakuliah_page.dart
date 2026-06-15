import 'package:flutter/material.dart';
import 'presensi_metode_numerik_page.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import '../../../services/admin/presensi_service.dart'; // Sesuaikan path

class PresensiMatakuliahPage extends StatefulWidget {
  // 🔥 1. Tambahkan parameter agar halaman tahu kelas mana yang dibuka
  final String idKelas;
  final String namaKelas;

  const PresensiMatakuliahPage({
    super.key, 
    required this.idKelas, 
    required this.namaKelas,
  });

  @override
  State<PresensiMatakuliahPage> createState() => _PresensiMatakuliahPageState();
}

class _PresensiMatakuliahPageState extends State<PresensiMatakuliahPage> {
  String sortById = "ID Matakuliah";
  
  // 🔥 2. State untuk API
  bool isLoading = true;
  List<dynamic> daftarMatakuliah = []; // Gunakan model Anda jika ada, misal List<MatakuliahModel>
  final PresensiService presensiService = PresensiService();

  @override
  void initState() {
    super.initState();
    loadDataMatakuliah();
  }

  // 🔥 3. Fungsi memanggil API Matakuliah per Kelas
  Future<void> loadDataMatakuliah() async {
    try {
      // Asumsi: Anda memiliki fungsi getJadwalPerKelas di PresensiService
      // yang memanggil ApiConfig.getJadwalPerKelas(widget.idKelas)
      final data = await presensiService.getJadwalPerKelas(widget.idKelas);
      
      if (mounted) {
        setState(() {
          daftarMatakuliah = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      debugPrint("Error load matakuliah: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Tampilkan Loading Spinner
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
          "Kembali ke daftar kelas",
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),

      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
    
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "Presensi Mahasiswa",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            const Text(
              "Presensi Mahasiswa Per Matakuliah",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 20),

            // ================= TABLE DAFTAR MATAKULIAH =================
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
                  // Header Tabel & Filter
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            // 🔥 Judul tabel jadi dinamis
                            "Daftar\nMatakuliah ${widget.namaKelas}",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.2),
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
                                  value: sortById,
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                                  items: ["ID Matakuliah", "Nama Matakuliah"].map((String value) {
                                    return DropdownMenuItem<String>(value: value, child: Text(value));
                                  }).toList(),
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

                  // Header Kolom Tabel
                  Container(
                    color: const Color(0xFFEFF6FF),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: const [
                        Expanded(flex: 3, child: Text("ID", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                        Expanded(flex: 4, child: Text("MATAKULIAH", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                        Expanded(flex: 3, child: Text("DOSEN", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                      ],
                    ),
                  ),

                  // 🔥 Data Row Tabel (Dari API)
                  if (daftarMatakuliah.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text("Belum ada matakuliah", style: TextStyle(color: Colors.grey))),
                    )
                  else
                    ...daftarMatakuliah.map((item) {
                      // Sesuaikan key json dengan response backend Anda
                      String idMk = item['id_mk'] ?? item['kode_mk'] ?? "-";
                      String namaMk = item['nama_mk'] ?? item['matakuliah'] ?? "-";
                      String namaDosen = item['nama_dosen'] ?? item['dosen'] ?? "-";

                      return _buildMatakuliahRow(
                        idMk, 
                        namaMk, 
                        namaDosen, 
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PresensiMetodeNumerikPage(
                                idMk: idMk,
                                namaMk:namaMk,
                                namaKelas:widget.namaKelas,
                              ),
                            ),
                          );
                        }
                      );
                    }).toList(),
                ],
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

  // Widget Baris Tabel Matakuliah
  Widget _buildMatakuliahRow(
    String id,
    String matakuliah,
    String dosen, [
    VoidCallback? onTap,
  ]) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                id,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                matakuliah,
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                dosen,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 11,
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