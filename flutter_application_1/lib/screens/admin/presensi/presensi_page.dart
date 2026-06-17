import 'package:flutter/material.dart';
import 'presensi_matakuliah_page.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import '../../../models/admin/kelas_presensi_model.dart';
import '../../../services/admin/presensi_service.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class PresensiPage extends StatefulWidget {
  const PresensiPage({super.key});

  @override
  State<PresensiPage> createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  String selectedProdi = "Semua Prodi";
  String selectedKelas = "Semua Kelas";
  String sortById = "ID/Kelas";
  
  bool isExpanded = false;
  bool isLoading = true;
  List<KelasPresensiModel> daftarKelas = [];
  final PresensiService presensiService = PresensiService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final data = await presensiService.getDaftarKelas();
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
      debugPrint("Error Load Presensi: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
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
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kembali",
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
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
              "Presensi",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            const Text(
              "Kelola Presensi/Kehadiran Mahasiswa",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 20),

            // ================= 4 STAT KOTAK =================
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_today,
                    iconBgColor: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF3B82F6),
                    topWidget: const Text("29 Apr 2026", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    value: daftarKelas.length.toString(),
                    label: "Total Kelas",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.how_to_reg,
                    iconBgColor: const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF22C55E),
                    topWidget: _buildTrendPill("+8.2%", const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                    value: "2.320",
                    label: "Hadir",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.medical_information_outlined,
                    iconBgColor: const Color(0xFFFFF7ED),
                    iconColor: const Color(0xFFF97316),
                    topWidget: _buildTrendPill("+8.2%", const Color(0xFFFFEDD5), const Color(0xFFEA580C)),
                    value: "151",
                    label: "Izin / Sakit",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.person_off_outlined,
                    iconBgColor: const Color(0xFFFEF2F2),
                    iconColor: const Color(0xFFEF4444),
                    topWidget: _buildTrendPill("+8.2%", const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
                    value: "50",
                    label: "Alfa",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ================= FILTER DROPDOWN =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown("Program Studi", selectedProdi, ["Semua Prodi", "Teknik Informatika", "Teknik Sipil"]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterDropdown("Kelas", selectedKelas, ["Semua Kelas", "AK-2A", "MI-2A", "TI-4C"]),
                  ),
                ],
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
                          "Daftar\nPresensi",
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
                                  items: ["ID/Kelas", "Terbaru", "Terlama"].map((String value) {
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

                  // Table Columns Title
                  Container(
                    color: const Color(0xFFEFF6FF),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: const [
                        Expanded(flex: 2, child: Text("ID", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                        Expanded(flex: 3, child: Text("KELAS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                        Expanded(flex: 4, child: Text("KEHADIRAN", textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
                      ],
                    ),
                  ),

                  // Table Rows Data (Dari API)
                  if (daftarKelas.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text("Data Kelas Kosong", style: TextStyle(color: Colors.grey))),
                    )
                  else
                    ...daftarKelas.map((item) => _buildTableRow(item.id, item.kelas)),
    
                  // Footer Lainnya
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isExpanded ? "Tutup" : "Lainnya",
                            style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700, fontSize: 13)
                          ),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: const Color(0xFF2563EB),
                            size: 18
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),
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
              onChanged: (val) {}, 
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(String id, String kelas) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PresensiMatakuliahPage(
              idKelas: id,
              namaKelas: kelas,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                id,
                style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                kelas,
                style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildMiniStat(Icons.check_circle_outline, "32", const Color(0xFF22C55E)),
                  const SizedBox(width: 8),
                  _buildMiniStat(Icons.access_time, "1", const Color(0xFFF97316)),
                  const SizedBox(width: 8),
                  _buildMiniStat(Icons.highlight_off, "2", const Color(0xFFEF4444)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ],
    );
  }
}