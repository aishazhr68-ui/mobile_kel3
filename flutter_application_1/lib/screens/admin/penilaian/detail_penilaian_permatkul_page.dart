import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/screens/admin/penilaian/detail_nilai_mahasiswa_page.dart';
import 'package:flutter_application_1/models/admin/nilai_model.dart';
import 'package:flutter_application_1/services/admin/nilai_service.dart';
import 'package:flutter_application_1/widgets/admin/student_nilai_card.dart';


class DetailPenilaianPerMatkulPage extends StatefulWidget {
  final String namaMatkul;
  final String kelas;

  const DetailPenilaianPerMatkulPage({
    super.key,
    required this.namaMatkul,
    required this.kelas,
  });

  @override
  State<DetailPenilaianPerMatkulPage> createState() =>
      _DetailPenilaianPerMatkulPageState();
}

class _DetailPenilaianPerMatkulPageState extends State<DetailPenilaianPerMatkulPage> {
  String sortById = "ID Matakuliah";
  bool showAllData = false;
  
  // Data Dummy Mahasiswa
  List<NilaiModel> mahasiswa = [];

bool isLoading = true;

final NilaiService nilaiService =
    NilaiService();

    Color getGradeColor(String grade) {
  switch (grade) {
    case "A":
      return const Color(0xFF22C55E);

    case "AB":
      return const Color(0xFF10B981);

    case "B":
      return const Color(0xFF3B82F6);

    default:
      return Colors.grey;
  }
}

    @override
    void initState() {
      super.initState();
      loadData();
    }
    Future<void> loadData() async {
  try {
    final data =
        await nilaiService.getNilaiMahasiswa();

    setState(() {
      mahasiswa = data;
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
  if (isLoading) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: -5,
        leadingWidth: 48,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF2563EB),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Kembali",
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
            fontSize: 14,
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
            Text(
              "Penilaian Matakuliah\n${widget.namaMatkul}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Kelola Nilai Mahasiswa Kelas ${widget.kelas}",
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filter Row
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4, right: 4, top: 8, bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: "Sort by: NIM (A-Z)",
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "Sort by: NIM (A-Z)",
                                child: Text(
                                  "Sort by: NIM (A-Z)",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                            onChanged: (_) {},
                          ),
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.filter_list,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // ================= HEADER TABEL =================
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFFEFF6FF),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "DATA MAHASISWA",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 35),
                            child: Text(
                              "GRADE",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= DATA MAHASISWA =================
            ...(showAllData ? mahasiswa : mahasiswa.take(6)).map(
              (m) => StudentNilaiCard(
                nim: m.nim,
                nama: m.nama,
                nilai: m.nilai.toString(),
                grade: m.grade,
                warna: getGradeColor(m.grade),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailNilaiMahasiswaPage(
                        nama: m.nama,
                        nim: m.nim,
                        nilai: m.nilai.toString(),
                        grade: m.grade,
                        matkul: widget.namaMatkul,
                        kelas: widget.kelas,
                      ),
                    ),
                  );
                },
              ),
            ).toList(),

                // ================= TOMBOL LAINNYA =================
                if (!showAllData)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showAllData = true;
                        });
                      },
                      child: Container(
                        width: 135,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFCBD5E1),
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Lainnya",
                              style: TextStyle(
                                color: Color(0xFF0A3490),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF0A3490),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
