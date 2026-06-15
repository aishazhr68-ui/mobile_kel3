// Lokasi: lib/screens/pages/mahasiswa/penilaian_matakuliah_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/mahasiswa/penilaian/penilaian_detail_page.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';
import '../../../models/mahasiswa/penilaian_matakuliah_model.dart';
import '../../../services/mahasiswa/penilaian_matakuliah_service.dart';
import 'package:flutter_application_1/screens/mahasiswa/penilaian/penilaian_detail_page.dart';

class PenilaianMatakuliahPage extends StatefulWidget {
  const PenilaianMatakuliahPage({super.key});

  @override
  State<PenilaianMatakuliahPage> createState() => _PenilaianMatakuliahPageState();
}

class _PenilaianMatakuliahPageState extends State<PenilaianMatakuliahPage> {
  bool isLoading = true;
  String sortBy = "ID Matakuliah";
  List<PenilaianMatakuliahModel> daftarMatkul = [];
  final PenilaianMatakuliahService _service = PenilaianMatakuliahService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getDaftarMatakuliah();
      if (!mounted) return;
      setState(() {
        daftarMatkul = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error : $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kembali",
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavMahasiswa(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Penilaian",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Penilaian Matakuliah",
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFDDE4EE)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Daftar\nMatakuliah TI-4C",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                            const Text("Sort\nby:",
                                style: TextStyle(
                                    fontSize: 10, color: Color(0xFF64748B))),
                            const SizedBox(width: 6),
                            Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: sortBy,
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      size: 18, color: Color(0xFF64748B)),
                                  items: ["ID Matakuliah"].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF475569))),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        sortBy = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.filter_alt_outlined,
                                  size: 18, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color(0xFFF1F5F9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        child: const Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text("ID",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF64748B)))),
                            Expanded(
                                flex: 4,
                                child: Text("MATAKULIAH",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF64748B)))),
                            Expanded(
                                flex: 4,
                                child: Text("DOSEN",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF64748B)))),
                          ],
                        ),
                      ),
                      ...daftarMatkul.map((data) => _buildRow(data)).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
    );
  }

  Widget _buildRow(PenilaianMatakuliahModel data) {
    return InkWell(
      onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PenilaianDetailPage(
            namaMatkul: data.namaMatkul,
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(data.id,
                style: const TextStyle(
                    color: Color(0xFF003EB3),
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ),
          Expanded(
            flex: 4,
            child: Text(data.namaMatkul,
                style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
          ),
          Expanded(
            flex: 4,
           child: Text(
              data.dosen,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
