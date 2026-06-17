import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart'; 
import 'package:flutter_application_1/models/admin/jadwal_kuliah_model.dart';
import 'package:flutter_application_1/services/admin/jadwal_kuliah_service.dart';
import 'package:flutter_application_1/screens/admin/jadwal/jadwal_detail_page.dart';

class JadwalKuliahPage extends StatefulWidget {
  const JadwalKuliahPage({super.key});

  @override
  State<JadwalKuliahPage> createState() => _JadwalKuliahPageState();
}

class _JadwalKuliahPageState extends State<JadwalKuliahPage> {
  bool isLoading = true;
  bool isExpanded = false; 
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
      if (mounted) {
        setState(() {
          daftarKelas = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      debugPrint("Gagal memuat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedData = isExpanded ? daftarKelas : daftarKelas.take(4).toList();
    final showLainnyaButton = daftarKelas.length > 4;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF1D4ED8)),
          label: const Text("Kembali", style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w600)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : daftarKelas.isEmpty 
            ? const Center(child: Text("Tidak ada jadwal tersedia"))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Jadwal Kuliah", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                    const Text("Jadwal Kuliah Mahasiswa Per Kelas", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                    const SizedBox(height: 20),
                    _buildFilterBox(),
                    const SizedBox(height: 24),
                    _buildSortBar(),
                    const SizedBox(height: 12),
                    ...displayedData.map((kelas) => _buildKelasCard(kelas)),
                    if (showLainnyaButton) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: GestureDetector(
                          onTap: () => setState(() => isExpanded = !isExpanded),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(isExpanded ? "Lebih Sedikit" : "Lainnya", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                                const SizedBox(width: 4),
                                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: const Color(0xFF64748B)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
    );
  }

  // --- KOMPONEN KARTU KELAS (Hanya ada SATU di sini) ---
  Widget _buildKelasCard(JadwalKelasModel kelas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(4)), child: Text(kelas.idKelas, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1D4ED8)))),
              Row(
                children: [
                  const Icon(Icons.group_outlined, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text("${kelas.jumlahMahasiswa} Mahasiswa", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(kelas.namaKelas, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
          Text(kelas.programStudi, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          const Divider(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JadwalDetailPage(idKelas: kelas.idKelas, namaKelas: kelas.namaKelas))),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Lihat Detail", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8))),
                  Icon(Icons.chevron_right, size: 16, color: Color(0xFF1D4ED8)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- KOMPONEN FILTER ---
  Widget _buildFilterBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Program Studi", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))), const SizedBox(height: 6), _buildDropdownDummy("Semua Prodi")])),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Kelas", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))), const SizedBox(height: 6), _buildDropdownDummy("Semua Kelas")])),
        ],
      ),
    );
  }

  Widget _buildDropdownDummy(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(hint, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))), const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF94A3B8))]),
    );
  }

  Widget _buildSortBar() {
    return Row(
      children: [
        const Text("Daftar Kelas", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFE2E8F0))), child: const Text("ID/Kelas", style: TextStyle(fontSize: 11, color: Color(0xFF475569)))),
      ],
    );
  }
}