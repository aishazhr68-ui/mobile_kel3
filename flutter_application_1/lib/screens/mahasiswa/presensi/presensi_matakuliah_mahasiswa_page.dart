import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/mahasiswa/presensi_matakuliah_model.dart';
import 'package:flutter_application_1/services/mahasiswa/presensi_matakuliah_service.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';
import 'presensi_detail_matkul_page.dart';

class PresensiMatakuliahMahasiswaPage extends StatefulWidget {
  const PresensiMatakuliahMahasiswaPage({super.key});

  @override
  State<PresensiMatakuliahMahasiswaPage> createState() =>
      _PresensiMatakuliahMahasiswaPageState();
}

class _PresensiMatakuliahMahasiswaPageState
    extends State<PresensiMatakuliahMahasiswaPage> {
  bool isLoading = true;

  List<PresensiMatakuliahMahasiswaModel> daftarPresensi = [];

  final PresensiMatakuliahMahasiswaService _service =
      PresensiMatakuliahMahasiswaService();

  String sortBy = "Nama Matakuliah";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getListPresensi();

      if (!mounted) return;

setState(() {
  daftarPresensi = data;

  daftarPresensi.sort((a, b) {
    const urutan = [
      "Pemrograman Perangkat Bergerak (4C)",
      "Keamanan Jaringan (4C)",
      "Pemrograman Web (4C)",
      "Metode Numerik (4C)",
      "Administrasi Database (4C)",
      "Kecerdasan Buatan (4C)",
      "Perancangan Perangkat Lunak Berbasis Objek (4C)",
    ];

    return urutan.indexOf(a.namaMatkul)
        .compareTo(
          urutan.indexOf(b.namaMatkul),
        );
  });

  isLoading = false;
});
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint("Gagal memuat data : $e");
    }
  }

  Color _getColor(int percentage) {
    if (percentage >= 90) {
      return const Color(0xFF16A34A);
    } else if (percentage >= 50) {
      return const Color(0xFFD97706);
    }

    return const Color(0xFFDC2626);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF2563EB),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kembali",
          style: TextStyle(
            color:  Color(0xFF2563EB),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavMahasiswa(),
   body: isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Presensi Matakuliah",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Monitor kehadiran perkuliahan Anda",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 16),

...daftarPresensi.map(
  (data) => GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PresensiDetailMatkulPage(
            namaMatkul: data.namaMatkul,
            persentase: data.persentase,
            sesiHadir: data.sesiHadir,
            totalSesi: data.totalSesi,
          ),
        ),
      );
    },
    child: _buildPresensiCard(data),
  ),
),

          const SizedBox(height: 24),

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
    );
  }

 Widget _buildPresensiCard(
  PresensiMatakuliahMahasiswaModel data,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFE5E7EB),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          data.namaMatkul,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),

        const SizedBox(height: 4),

        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 10,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(width: 4),
            Text(
              "Pertemuan Ke-${data.totalSesi}",
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Kehadiran: ${data.sesiHadir} dari ${data.totalSesi} sesi",
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF64748B),
              ),
            ),

            Text(
              "${data.persentase}%",
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: data.persentase / 100,
            minHeight: 5,
            backgroundColor:
                const Color(0xFFE5E7EB),
            valueColor:
                const AlwaysStoppedAnimation<Color>(
              Color(0xFF2563EB),
            ),
          ),
        ),
      ],
    ),
  );
}
}