import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/models/admin/detail_khs_model.dart';
import 'package:flutter_application_1/services/admin/detail_khs_service.dart';

class DetailKhsPage extends StatefulWidget {
  final String nim; // Digunakan untuk fetch data berdasarkan mahasiswa

  const DetailKhsPage({super.key, required this.nim});

  @override
  State<DetailKhsPage> createState() => _DetailKhsPageState();
}

class _DetailKhsPageState extends State<DetailKhsPage> {
  bool isLoading = true;
  StudentDetailModel? studentData;
  final StudentDetailService _service = StudentDetailService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getDetailMahasiswa(widget.nim);
      setState(() {
        studentData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Gagal memuat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (studentData == null) {
      return const Scaffold(
        body: Center(child: Text("Data mahasiswa tidak ditemukan")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leadingWidth: 260,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF1D4ED8)),
            label: const Text(
              "Kembali Ke daftar Mahasiswa",
              style: TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "KHS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Detail KHS Mahasiswa",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
            const SizedBox(height: 20),

            // CARD INFO MAHASISWA
            _buildStudentInfoCard(studentData!),

            const SizedBox(height: 24),
            
            const Text(
              "DAFTAR MATAKULIAH",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 12),

            // LIST MATA KULIAH
            ...studentData!.courses.map((course) => _buildCourseCard(course)),

          // RINGKASAN NILAI
const SizedBox(height: 12),

Row(
  children: [

    // TOTAL SKS
    Expanded(
      flex: 2,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF0A4CC5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(height: 8),
            Text(
              "TOTAL SKS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "18",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    ),

    const SizedBox(width: 12),

    // IPS & IPK
    Expanded(
      child: Column(
        children: [

          // IPS
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IPS",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      "3.86",
                      style: TextStyle(
                        color: Color(0xFF0A4CC5),
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                CircleAvatar(
                  radius: 10,
                  backgroundColor:
                      Color(0xFFDCFCE7),
                  child: Icon(
                    Icons.trending_up,
                    size: 12,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // IPK
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IPK",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      "3.93",
                      style: TextStyle(
                        color: Color(0xFF0A4CC5),
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                CircleAvatar(
                  radius: 10,
                  backgroundColor:
                      Color(0xFFDBEAFE),
                  child: Icon(
                    Icons.remove_red_eye,
                    size: 12,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
),
const SizedBox(height: 40),

            // FOOTER
            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.5),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

Widget _buildStudentInfoCard(StudentDetailModel data) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: const Color(0xFFE2E8F0),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // FOTO + NAMA
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 32,
                color: Color(0xFF64748B),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    data.nama,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "NIM: ${data.nim}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Divider(
          color: Color(0xFFE5E7EB),
          thickness: 1,
        ),

        const SizedBox(height: 12),

        // PRODI & KELAS
        Row(
          children: [

            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "PROGRAM STUDI",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    data.programStudi,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "KELAS",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    data.kelas,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        const Divider(
          color: Color(0xFFE5E7EB),
          thickness: 1,
        ),

        const SizedBox(height: 12),

        // DOSEN + STATUS
        Row(
          children: [

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "DOSEN PEMBIMBING",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    data.dosenPembimbing,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                data.status.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
    Widget _buildCourseCard(CourseModel course) {
  String grade = "A";
  String nilai = "4.00";

  if (course.namaMataKuliah.contains("Metode")) {
    grade = "AB";
    nilai = "3.50";
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 12,
    ),
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                course.namaMataKuliah,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Text(
                    "${course.kode} • ${course.sks} SKS",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    "${course.sks} SKS",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            const Text(
              "Nilai",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
              ),
            ),

            Text(
              nilai,
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
          ],
        ),

        const SizedBox(width: 12),

        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: grade == "AB"
                ? const Color(0xFFE5E7EB)
                : const Color(0xFF1D4ED8),
            shape: BoxShape.circle,
          ),
          child: Text(
            grade,
            style: TextStyle(
              color: grade == "AB"
                  ? const Color(0xFF64748B)
                  : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
  }