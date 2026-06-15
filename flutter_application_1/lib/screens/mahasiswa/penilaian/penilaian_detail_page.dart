// Lokasi: lib/screens/pages/mahasiswa/penilaian_detail_page.dart
import 'package:flutter/material.dart';
import '../../../models/mahasiswa/penilaian_detail_model.dart';
import '../../../services/mahasiswa/penilaian_detail_service.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';

class PenilaianDetailPage extends StatefulWidget {
  final String namaMatkul;

  const PenilaianDetailPage({
    super.key,
    required this.namaMatkul,
  });

  @override
  State<PenilaianDetailPage> createState() => _PenilaianDetailPageState();
}

class _PenilaianDetailPageState extends State<PenilaianDetailPage> {
  bool isLoading = true;
  late PenilaianDetailModel detail;
  final PenilaianDetailService _service = PenilaianDetailService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await _service.getDetailNilai(widget.namaMatkul);
    if (!mounted) return;
    setState(() {
      detail = data;
      isLoading = false;
    });
  }

  // Fungsi helper untuk menentukan Icon dan Warna berdasarkan nama komponen
  Map<String, dynamic> _getIconProps(String komponen) {
    String text = komponen.toLowerCase();
    if (text.contains("tugas")) {
      return {"icon": Icons.assignment, "color": const Color(0xFF2563EB)};
    } else if (text.contains("aktivitas")) {
      return {"icon": Icons.people, "color": const Color(0xFF22C55E)};
    } else if (text.contains("uts")) {
      return {"icon": Icons.text_snippet, "color": const Color(0xFFF97316)};
    } else if (text.contains("uas")) {
      return {"icon": Icons.text_snippet, "color": const Color(0xFFEF4444)};
    } else {
      return {"icon": Icons.folder, "color": const Color(0xFF8B5CF6)};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kembali ke daftar matakuliah",
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavMahasiswa(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text("Penilaian",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                const Text("Penilaian Matakuliah",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                const SizedBox(height: 20),
                
                _buildInfoCard(),
                const SizedBox(height: 16),
                
                _buildRincianNilai(),
                const SizedBox(height: 16),
                
                _buildHasilProyek(),
                const SizedBox(height: 40),

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
  
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(detail.namaMatkul, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
          const SizedBox(height: 6),
          Text(detail.kodeMatkul, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          const Text("Dosen Pengampu", style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(detail.dosen, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF374151))),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _buildRincianNilai() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Rincian Nilai", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF1E293B)))),
          ),
          
          // HEADER TABEL
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(children: [
              Expanded(flex: 5, child: Text("KOMPONEN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)))),
              Expanded(flex: 2, child: Text("BOBOT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)))),
              Expanded(flex: 2, child: Text("NILAI", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)))),
              Expanded(flex: 2, child: Text("AKHIR", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)))),
            ]),
          ),

          // ISI TABEL
          ...detail.rincian.map((item) {
            final iconProps = _getIconProps(item.komponen);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: iconProps["color"].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(iconProps["icon"], size: 14, color: iconProps["color"]),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.komponen,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF334155)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: Text("${item.bobot}%", style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
                    Expanded(flex: 2, child: Text("${item.nilai}", style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
                    Expanded(flex: 2, child: Text("${item.akhir}", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFF2563EB)))),
                  ]),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHasilProyek() {
    return Column(
      children: [
        // CARD KECIL HASIL PROYEK
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hasil Proyek", style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF334155))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.description_outlined, size: 15, color: Color(0xFFF97316)),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(child: Text("Sistem Informasi Akademik", style: TextStyle(fontSize: 12, color: Color(0xFF334155)))),
                    const Text("74", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // CARD NILAI AKHIR (BACKGROUND BIRU PEKAT)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF003EB3), // Warna Biru Pekat
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TOTAL NILAI AKHIR", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8))),
                        const SizedBox(height: 4),
                        Text(detail.totalNilai.toString(), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text("GRADE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 8),
                      Container(
                        width: 54, height: 54,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        alignment: Alignment.center,
                        child: Text(detail.grade, style: const TextStyle(color: Color(0xFF003EB3), fontSize: 24, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(height: 8),
                      Text("Total 100%", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Row untuk menyejajarkan teks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Distribusi Bobot Penilaian", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                  Text("Total 100%", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8))),
                ],
              ),
              
              const SizedBox(height: 12),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    Expanded(flex: 20, child: Container(height: 8, color: const Color(0xFF60A5FA))),
                    Expanded(flex: 20, child: Container(height: 8, color: const Color(0xFF22C55E))),
                    Expanded(flex: 20, child: Container(height: 8, color: const Color(0xFFF97316))),
                    Expanded(flex: 30, child: Container(height: 8, color: const Color(0xFFEF4444))),
                    Expanded(flex: 10, child: Container(height: 8, color: const Color(0xFF8B5CF6))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _legend(const Color(0xFF60A5FA), Icons.assignment, "Tugas (20%)"),
                  _legend(const Color(0xFF22C55E), Icons.people, "Aktivitas (20%)"),
                  _legend(const Color(0xFFF97316), Icons.text_snippet, "UTS (20%)"),
                  _legend(const Color(0xFFEF4444), Icons.text_snippet, "UAS (30%)"),
                  _legend(const Color(0xFF8B5CF6), Icons.folder, "Hasil Proyek (10%)"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

 Widget _legend(Color color, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
