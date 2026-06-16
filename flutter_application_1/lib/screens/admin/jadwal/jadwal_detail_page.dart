import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/models/admin/jadwal_detail_model.dart';
import 'package:flutter_application_1/services/admin/jadwal_detail_service.dart';
import 'package:collection/collection.dart'; 

class JadwalDetailPage extends StatefulWidget {
  final String namaKelas;
  const JadwalDetailPage({super.key, required this.namaKelas});

  @override
  State<JadwalDetailPage> createState() => _JadwalDetailPageState();
}

class _JadwalDetailPageState extends State<JadwalDetailPage> {
  bool isLoading = true;
  // 1. PASTIKAN VARIABEL INI ADA DI SINI (Di luar fungsi)
  Map<String, List<JadwalMataKuliah>> groupedJadwal = {};
  final JadwalDetailService _service = JadwalDetailService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getJadwalDetail(widget.namaKelas);
      
      // 2. Lakukan grouping
      final grouped = groupBy(data, (JadwalMataKuliah m) => m.hari ?? "Tidak Diketahui");
      
      if (mounted) {
        setState(() {
          // 3. Masukkan ke variabel state
          groupedJadwal = Map<String, List<JadwalMataKuliah>>.from(grouped);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Gagal memuat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            label: const Text("Kembali", style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1.0), child: Container(color: const Color(0xFFE2E8F0), height: 1.0)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Jadwal Kuliah", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                  const SizedBox(height: 4),
                  Text(widget.namaKelas, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                  const SizedBox(height: 20),

                  // 4. RENDERING DINAMIS: Data dari API
                  // Jika data kosong, tampilkan pesan
                  groupedJadwal.isEmpty 
                    ? _buildTidakAdaJadwal()
                    : Column(
                        children: groupedJadwal.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHari(entry.key),
                              const SizedBox(height: 10),
                              ...entry.value.map((m) => _buildJadwalCard(
                                    bgColor: const Color(0xFFDCECF9),
                                    titleColor: const Color(0xFF0F4C81),
                                    jam: m.waktu,
                                    matkul: m.namaMataKuliah,
                                    ruang: m.ruang,
                                  )),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      ),

                  const Center(
                    child: Text("© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                        textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.5)),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  // --- Widget Helper (Sama persis agar desain tidak berubah) ---
  Widget _buildHari(String hari) {
    return Row(children: [const CircleAvatar(radius: 2, backgroundColor: Color(0xFF1D4ED8)), const SizedBox(width: 8), Text(hari, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF334155)))]);
  }

  Widget _buildJadwalCard({required Color bgColor, required Color titleColor, required String jam, required String matkul, required String ruang}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(jam, style: TextStyle(color: titleColor, fontSize: 10)), const SizedBox(height: 4), Text(matkul, style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w700))])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(6)), child: Text(ruang, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)))),
      ]),
    );
  }

  Widget _buildTidakAdaJadwal() {
    return Container(height: 56, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD1D5DB))), child: const Center(child: Text("Tidak ada jadwal kuliah", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12))));
  }
}