// Lokasi: lib/screens/pages/presensi/presensi_detail_matkul_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';
import '../../../models/mahasiswa/presensi_detail_matkul_model.dart';
import '../../../services/mahasiswa/presensi_detail_matkul_service.dart';

class PresensiDetailMatkulPage extends StatefulWidget {
  final String namaMatkul;
  final int persentase;
  final int sesiHadir;
  final int totalSesi;

  const PresensiDetailMatkulPage({
    super.key,
    required this.namaMatkul,
    required this.persentase,
    required this.sesiHadir,
    required this.totalSesi,
  });

  @override
  State<PresensiDetailMatkulPage> createState() =>
      _PresensiDetailMatkulPageState();
}

class _PresensiDetailMatkulPageState extends State<PresensiDetailMatkulPage> {
  bool showAll = false;
  bool isLoading = true;

  List<DetailSesiPresensiModel> daftarSesi = [];

  final PresensiDetailMatkulService _service = PresensiDetailMatkulService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getDetailPresensi(
        widget.namaMatkul,
      );

      if (!mounted) return;

      setState(() {
        daftarSesi = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint(
        "Gagal memuat detail presensi: $e",
      );
    }
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // CARD ATAS
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      // ==========================================
                      // LINGKARAN BIRU YANG SUDAH DIPROPORSIKAN
                      // ==========================================
                      SizedBox(
                        width: 75, 
                        height: 75,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: widget.persentase / 100,
                                strokeWidth: 8, 
                                strokeCap: StrokeCap.round, 
                                color: const Color(0xFF2563EB),
                                backgroundColor: const Color(0xFFDBEAFE), 
                              ),
                            ),
                            Text(
                              "${widget.persentase}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20, // Font disesuaikan dengan lingkaran
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ==========================================

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.namaMatkul,
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "D3 Teknik Informatika",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(0xFF2563EB),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Presensi: ${widget.sesiHadir} / ${widget.totalSesi} Sesi",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF334155),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "DAFTAR SESI",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      "Total ${widget.totalSesi} Sesi",
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                for (var sesi in (showAll ? daftarSesi : daftarSesi.take(3)))
                  _buildSesiCard(sesi),

                const SizedBox(height: 10),

                if (!showAll)
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showAll = true;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text("Lainnya"),
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

  Widget _buildSesiCard(DetailSesiPresensiModel sesi) {
    final bool hadir = sesi.status.toUpperCase() == "HADIR";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEFF6FF),
            child: Text(
              "${sesi.nomorSesi}",
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        sesi.tanggal,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hadir
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sesi.status,
                        style: TextStyle(
                          color: hadir
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFDC2626),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${sesi.waktu} • Ruang ${sesi.ruang}",
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  sesi.materi,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Dosen: ${sesi.dosen}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}