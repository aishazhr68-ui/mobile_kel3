import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/mahasiswa/krs_model.dart';
import 'package:flutter_application_1/services/mahasiswa/krs_service.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';

class KrsMhsPage extends StatefulWidget {
  const KrsMhsPage({super.key});

  @override
  State<KrsMhsPage> createState() => _KrsMhsPageState();
}

class _KrsMhsPageState extends State<KrsMhsPage> {
  bool isLoading = true;

  late KrsInfoModel infoKrs;

  List<MatkulModel> daftarMatkul = [];
  List<PilihanKelasModel> pilihanKelas = [];

  final List<int> selectedIndex = [];

  final KrsService _service = KrsService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final info = await _service.getInfoKrs();
      final matkul = await _service.getDaftarMatkul();
      final pilihan = await _service.getPilihanKelas();

      if (!mounted) return;

      setState(() {
        infoKrs = info;
        daftarMatkul = matkul;
        pilihanKelas = pilihan;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      debugPrint("Error loading KRS: $e");
    }
  }

  void _showBottomSheetKrs() {
      if (!infoKrs.isApproved && selectedIndex.isEmpty) {
    for (int i = 0; i < pilihanKelas.length; i++) {
      selectedIndex.add(i);
    }
  }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pengisian Kartu Rencana Studi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),

                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: infoKrs.isApproved
                        ? _buildApprovedBottomSheet()
                        : _buildNotApprovedBottomSheet(setModalState),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

void _showKonfirmasiSimpanKrs() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF59E0B),
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.priority_high,
                  color: Color(0xFFF59E0B),
                  size: 34,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Simpan KRS?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 18),

           Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFFFFFBEB),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color(0xFFFDE68A),
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Perhatian :",
        style: TextStyle(
          color: Color(0xFFC2410C),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),

      const SizedBox(height: 14),

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.send_outlined,
            color: Color(0xFFF59E0B),
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              "Proses ini akan mengirim KRS untuk diajukan ke dosen pembimbing.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 16),

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline,
            color: Color(0xFFF59E0B),
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              "Kelas yang dipilih tidak dapat diubah setelah KRS disimpan.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // TODO: simpan ke API
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0047CC),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Ya, Simpan dan Ajukan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Batal",
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
  Widget _buildApprovedBottomSheet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _miniInfo(
                  "SEMESTER SAAT INI",
                  "Semester 4",
                ),
              ),
              Expanded(
                child: _miniInfo(
                  "BATAS TOTAL SKS",
                  "24 SKS",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _miniInfo(
                  "PERIODE AKADEMIK",
                  "2025 Genap",
                ),
              ),
              Expanded(
                child: _miniInfo(
                  "STATUS",
                  "KRS sudah divalidasi",
                  isGreen: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info,
                  color: Color(0xFF2563EB),
                  size: 18,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    "KRS Telah Divalidasi dan tidak bisa diubah. Untuk pembatalan validasi KRS silakan menghubungi Pembimbing Akademik terkait.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "KRS Tersimpan",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: daftarMatkul.length,
              itemBuilder: (context, index) {
                final data = daftarMatkul[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          "${data.kode} - ${data.nama}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Text(
                          data.jadwal,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),

                      Text(
                        "${data.sks} SKS",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF0047CC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "Total ${daftarMatkul.fold(0, (sum, item) => sum + item.sks)} SKS",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotApprovedBottomSheet(StateSetter setModalState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "PILIH KELAS",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: ListView.builder(
              itemCount: pilihanKelas.length,
              itemBuilder: (context, index) {
                final data = pilihanKelas[index];

                final isSelected = selectedIndex.contains(index);

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.kode,
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              data.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Color(0xFF64748B),
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  data.jadwal,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                const Icon(
                                  Icons.menu_book,
                                  size: 12,
                                  color: Color(0xFF64748B),
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  "${data.sks} SKS",
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Checkbox(
                        value: isSelected,
                        activeColor: const Color(0xFF2563EB),
                        onChanged: (value) {
                          setModalState(() {
                            if (value == true) {
                              selectedIndex.add(index);
                            } else {
                              selectedIndex.remove(index);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "RINGKASAN PENGAJUAN",
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "Total ${_totalSks()} SKS",
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Batal"),
                ),
              ),

              const SizedBox(width: 14),

        Expanded(
          child: ElevatedButton(
            onPressed: _showKonfirmasiSimpanKrs,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0047CC),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Simpan KRS",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  int _totalSks() {
    int total = 0;

    for (var i in selectedIndex) {
      total += pilihanKelas[i].sks;
    }

    return total;
  }

  Widget _miniInfo(
    String title,
    String value, {
    bool isGreen = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: isGreen
                ? const Color(0xFF16A34A)
                : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
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
      backgroundColor: const Color(0xFFF8FAFC),

      bottomNavigationBar: const CustomBottomNavMahasiswa(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 120,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1E40AF),
          ),
          label: const Text(
            "Kembali",
            style: TextStyle(
              color: Color(0xFF1E40AF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Kartu Rencana Studi",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),

          const Text(
            "Detail KRS Mahasiswa",
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _showBottomSheetKrs,
              icon: const Icon(Icons.calendar_today, size: 18),
              label: const Text("Pilih Kelas"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 32,
                        color: Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          infoKrs.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "NIM: ${infoKrs.nim}",
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        "PROGRAM STUDI",
                        infoKrs.prodi,
                      ),
                    ),

                    Expanded(
                      child: _buildInfoItem(
                        "KELAS",
                        infoKrs.kelas,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 30),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DOSEN PEMBIMBING\n${infoKrs.dosenWali}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: infoKrs.isApproved
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        infoKrs.isApproved
                            ? "DISETUJUI"
                            : "BELUM DISETUJUI",
                        style: TextStyle(
                          color: infoKrs.isApproved
                              ? const Color(0xFF166534)
                              : const Color(0xFF92400E),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "DAFTAR MATAKULIAH YANG DIAMBIL",
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...daftarMatkul.map(
            (matkul) => _buildRowMatkul(matkul),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF003EB3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOTAL SKS",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "${daftarMatkul.fold(0, (sum, item) => sum + item.sks)} SKS",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
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

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1E40AF),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildRowMatkul(MatkulModel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.book,
                size: 18,
                color: Color(0xFF2563EB),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  data.nama,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${data.sks} SKS",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            data.kode,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 12,
                color: Color(0xFF64748B),
              ),

              const SizedBox(width: 4),

              Text(
                data.jadwal,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF475569),
                ),
              ),

              const SizedBox(width: 12),

              const Icon(
                Icons.person,
                size: 12,
                color: Color(0xFF64748B),
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  data.dosen,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}