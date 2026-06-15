// Lokasi: lib/screens/jadwal_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/admin/jadwal_detail_model.dart';
import 'package:flutter_application_1/services/admin/jadwal_detail_service.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';

class JadwalDetailMahasiswaPage extends StatefulWidget {
  final String namaKelas;

  const JadwalDetailMahasiswaPage({super.key, required this.namaKelas});

  @override
  State<JadwalDetailMahasiswaPage> createState() => _JadwalDetailMahasiswaPageState();
}

class _JadwalDetailMahasiswaPageState extends State<JadwalDetailMahasiswaPage> {
  bool isLoading = true;
  bool isExpanded = false;
  List<JadwalMataKuliah> daftarMatkul = [];
  final JadwalDetailService _service = JadwalDetailService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getJadwalDetail(widget.namaKelas);
      setState(() {
        daftarMatkul = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Gagal memuat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavMahasiswa(),
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 260,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF1D4ED8)),
            label: const Text(
              "Kembali",
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  const Text(
                    "Jadwal PerKuliahan",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Semua jadwal kuliah di semester 4", // <--- UBAH TEKSNYA DI SINI
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  // LIST MATA KULIAH
                  // SENIN
                  _buildHari("Senin"),
                  const SizedBox(height: 10),
                  _buildJadwalCard(
                    bgColor: const Color(0xFFDCECF9),
                    titleColor: const Color(0xFF0F4C81),
                    jam: "08.00 - 09.40",
                    matkul: "PPLBO",
                    ruang: "H-203",
                  ),
                  const SizedBox(height: 10),
                  _buildJadwalCard(
                    bgColor: const Color(0xFFF7E4CB),
                    titleColor: const Color(0xFFC2410C),
                    jam: "13.30 - 16.00",
                    matkul: "PPB",
                    ruang: "UPT-TIK 103",
                  ),
                  const SizedBox(height: 20),

                  // SELASA
                  _buildHariAbu("Selasa"),
                  const SizedBox(height: 10),
                  _buildTidakAdaJadwal(),
                  const SizedBox(height: 20),

                  // RABU
                  _buildHari("Rabu"),
                  const SizedBox(height: 10),
                  _buildJadwalCard(
                    bgColor: const Color(0xFFDDF3E3),
                    titleColor: const Color(0xFF15803D),
                    jam: "08.00 - 12.10",
                    matkul: "Pemrograman Web",
                    ruang: "Lab. Rekayasa 1",
                  ),
                  const SizedBox(height: 10),
                  _buildJadwalCard(
                    bgColor: const Color(0xFFE8EEF8),
                    titleColor: const Color(0xFF1D4ED8),
                    jam: "13.30 - 18.00",
                    matkul: "Administrasi Database",
                    ruang: "UPT-TIK 103",
                  ),
                  const SizedBox(height: 20),

                  // KAMIS
                  _buildHari("Kamis"),
                  const SizedBox(height: 10),
                  _buildJadwalCard(
                    bgColor: const Color(0xFFFCE8CC),
                    titleColor: const Color(0xFFEA580C),
                    jam: "08.00 - 10.30",
                    matkul: "Metode Numerik",
                    ruang: "Lab. AI/VR",
                  ),
                  const SizedBox(height: 20),

                  // JUMAT
                  _buildHari("Jumat"),
                  const SizedBox(height: 10),
                  _buildJadwalCard(
                    bgColor: const Color(0xFFFCE0EC),
                    titleColor: const Color(0xFFE11D48),
                    jam: "08.00 - 12.10",
                    matkul: "Keamanan Jaringan",
                    ruang: "Lab. Jaringan",
                  ),
                  const SizedBox(height: 10),
                  _buildJadwalCard(
                    bgColor: const Color(0xFFFCE0EC),
                    titleColor: const Color(0xFFE11D48),
                    jam: "13.30 - 18.00",
                    matkul: "Kecerdasan Buatan",
                    ruang: "H-205",
                  ),
                  const SizedBox(height: 24),

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
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  // Desain Kartu Sesuai Gambar Terbaru
  Widget _buildMatkulCard(JadwalMataKuliah matkul) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Color(0xFF1D4ED8), width: 4), // Garis biru tebal di kiri
              top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
              right: BorderSide(color: Color(0xFFF1F5F9), width: 1),
              bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BAGIAN KIRI: Mata Kuliah, SKS, Waktu, Ruang
              Expanded(
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      matkul.namaMataKuliah,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        // Badge SKS (Orange)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5), // Latar orange pudar
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${matkul.sks} SKS",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFEA580C), // Teks orange gelap
                            ),
                          ),
                        ),
                        // Badge Waktu (Biru)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE), // Latar biru pudar
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            matkul.waktu,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                        // Badge Ruang (Abu-abu)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9), // Latar abu-abu
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            matkul.ruang,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // BAGIAN KANAN: Nama Dosen
              Expanded(
                flex: 8,
                child: Text(
                  matkul.namaDosen,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    height: 1.3, // Memberikan sedikit rongga agar teks rapi jika panjang
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHari(String hari) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 2,
          backgroundColor: Color(0xFF1D4ED8),
        ),
        const SizedBox(width: 8),
        Text(
          hari,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  Widget _buildHariAbu(String hari) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 2,
          backgroundColor: Color(0xFF94A3B8),
        ),
        const SizedBox(width: 8),
        Text(
          hari,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildTidakAdaJadwal() {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD1D5DB),
        ),
      ),
      child: const Center(
        child: Text(
          "Tidak ada jadwal kuliah",
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildJadwalCard({
    required Color bgColor,
    required Color titleColor,
    required String jam,
    required String matkul,
    required String ruang,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jam,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  matkul,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              ruang,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}