import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/models/admin/krs_model.dart';
import 'package:flutter_application_1/services/admin/krs_service.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/screens/admin/krs/krs_kelas_page.dart';


class KrsPage extends StatefulWidget {
  const KrsPage({super.key});

  @override
  State<KrsPage> createState() => _KrsPageState();
}

class _KrsPageState extends State<KrsPage> {
  String selectedProdi = "Semua Prodi";
  String selectedKelas = "Semua Kelas";

  bool isExpanded = false; // State untuk mendeteksi list diperluas/tidak

  List<KrsModel> dataKrs = [];
  bool isLoading = true;

  final KrsService krsService = KrsService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final data = await krsService.getKrs();
      setState(() {
        dataKrs = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // LOADING STATE
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // EMPTY STATE
    if (dataKrs.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Data KRS tidak tersedia",
          ),
        ),
      );
    }

    // LOGIK EXPAND LIST:
    // Menampilkan 5 data pertama jika belum di-expand, tampilkan semua jika di-expand
    final List<KrsModel> displayedKrs = isExpanded 
        ? dataKrs 
        : dataKrs.take(5).toList();

    // Cek apakah data aslinya lebih dari 5 item untuk menentukan apakah tombol "Lainnya" perlu ditampilkan
    final bool showLainnyaButton = dataKrs.length > 5;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leadingWidth: 100,
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
              "Kembali",
              style: TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
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
              "Kartu Rencana Studi Mahasiswa",
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // FILTER CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Program Studi",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField(
                          value: selectedProdi,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF1F5F9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "Semua Prodi",
                              child: Text("Semua Prodi", style: TextStyle(fontSize: 13)),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField(
                          value: selectedKelas,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF1F5F9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "Semua Kelas",
                              child: Text("Semua Kelas", style: TextStyle(fontSize: 13)),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // TABEL KRS
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Daftar KRS\nBerdasarkan Kelas",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const Text(
                          "Sort\nby:",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                "ID/Kelas",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, size: 14),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.filter_list,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Header Kolom Tabel
                  Container(
                    color: const Color(0xFFF1F5F9),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "ID",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "KELAS",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "KEHADIRAN",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Data Tabel -> menggunakan list yang sudah difilter/dipotong
                  ...displayedKrs.map((item) => _buildRow(item)),

                  // Tombol Lainnya hanya tampil jika datanya lebih dari 5 item
                  if (showLainnyaButton)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Lainnya",
                                style: TextStyle(
                                  color: Color(0xFF1D4ED8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                isExpanded 
                                    ? Icons.keyboard_arrow_up // Panah ke atas jika terbuka
                                    : Icons.keyboard_arrow_down, // Panah ke bawah jika tertutup
                                color: const Color(0xFF1D4ED8),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 8), // Padding jika tidak ada tombol lainnya
                ],
              ),
            ),
            const SizedBox(height: 35),

            // FOOTER
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

 Widget _buildRow(KrsModel item) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KrsKelasPage(
           namaKelas: item.kelas,
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.id,
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              item.kelas,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF16A34A),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${item.hadir}",
                    style: const TextStyle(
                      color: Color(0xFF16A34A),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFDC2626),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${item.izin}",
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF64748B),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}