import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/mahasiswa/status_semester_model.dart';
import 'package:flutter_application_1/services/mahasiswa/status_semester_service.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';

class StatusSemesterPage extends StatefulWidget {
  const StatusSemesterPage({super.key});

  @override
  State<StatusSemesterPage> createState() => _StatusSemesterPageState();
}

class _StatusSemesterPageState extends State<StatusSemesterPage> {
  final StatusSemesterService _service = StatusSemesterService();
  List<StatusSemesterModel> _riwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _service.getRiwayatSemester();
    if (!mounted) return;
    setState(() {
      _riwayat = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFFF8FAFC),
  bottomNavigationBar: const CustomBottomNavMahasiswa(),
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Color(0xFF1E40AF),
      ),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text(
      "Status Semester",
      style: TextStyle(
        color: Color(0xFF1E40AF),
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
body: _isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Status Semester",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                height: 1,
              ),
            ),

            const SizedBox(height: 2),

            const Text(
              "Data Per Semester Mahasiswa",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            _buildProfileCard(),

            const SizedBox(height: 16),

            ..._riwayat.map(
              (e) => _buildSemesterCard(e),
            ),

            const SizedBox(height: 32),

            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF94A3B8),
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

Widget _buildProfileCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E7FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF2563EB),
                size: 30,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Aufa Qonita Salsabila",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "NIM: C030324011",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Aktif",
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        const Divider(height: 1),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "PROGRAM STUDI",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "D3 Teknik Informatika",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "KELAS",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "TI-4C",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        const Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TAHUN AKADEMIK",
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "2025/2026",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSemesterCard(StatusSemesterModel data) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF0D5BD7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.semester.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                data.tahunAkademik,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      "STATUS",
                      data.status,
                      const Color(0xFF16A34A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _statCard(
                      "SKS",
                      data.sks,
                      const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _statCard(
                      "IPS",
                      data.ips,
                      const Color(0xFF334155),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Table(
                border: TableBorder.all(
                  color: const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xFFF8FAFC),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "Kategori",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "Tempuh",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "Lulus",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),

                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Total SKS",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          data.sks,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          data.sks,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          data.sks,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "IPK",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("-"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          data.ipk,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          data.ipk,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _statCard(
  String label,
  String value,
  Color valueColor,
) {
  return Container(
    height: 48,
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(2),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
      ],
    );
  }
}