import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/mahasiswa/tagihan_model.dart';
import 'package:flutter_application_1/services/mahasiswa/tagihan_service.dart';

// --- TAMBAHAN: Model Lokal untuk Riwayat ---
class RiwayatModel {
  final String namaTagihan;
  final String semester;
  final int nominal;
  final String waktuKonfirmasi;

  RiwayatModel({
    required this.namaTagihan,
    required this.semester,
    required this.nominal,
    required this.waktuKonfirmasi,
  });
}
// -------------------------------------------

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  final TagihanService _service = TagihanService();

  List<TagihanModel> tagihan = [];
  
  // --- TAMBAHAN: State untuk Riwayat ---
  List<RiwayatModel> riwayat = [];
  // -------------------------------------
  
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    tagihan = await _service.getTagihan();

    // --- TAMBAHAN: Data Dummy Riwayat Pembayaran ---
    riwayat = [
      RiwayatModel(
        namaTagihan: "UKT",
        semester: "Genap 2025/2026",
        nominal: 3500000,
        waktuKonfirmasi: "14 Juni 2026 10:30 WITA",
      ),
    ];
    // -----------------------------------------------

    setState(() {
      isLoading = false;
    });
  }

  int get totalBayar {
    return tagihan
        .where((e) => e.selected)
        .fold(0, (sum, item) => sum + item.nominal);
  }

  String formatRupiah(int value) {
    return value
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text(
            "Tagihan Keuangan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: const TabBar(
                      indicatorColor: Color(0xFF0052CC),
                      labelColor: Color(0xFF0052CC),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Belum Dibayar"),
                        Tab(text: "Riwayat Pembayaran"),
                      ],
                    ),
                  ),
                  Expanded(
                    // --- MODIFIKASI: Menambahkan TabBarView agar Tab berfungsi ---
                    child: TabBarView(
                      children: [
                        // TAB 1: KODE ASLI ANDA
                        tagihan.isEmpty
                            ? _buildEmptyState()
                            : ListView(
                                children: [_buildTagihanList()],
                              ),

                        // TAB 2: TAMBAHAN UNTUK RIWAYAT
                        riwayat.isEmpty 
                            ? _buildEmptyStateRiwayat() 
                            : _buildRiwayatList(),
                      ],
                    ),
                    // -------------------------------------------------------------
                  ),
                ],
              ),
        bottomNavigationBar: tagihan.isEmpty
            ? _buildBottomKosong()
            : _buildBottomBayar(),
      ),
    );
  }

  // ===========================================================================
  // KODE ASLI ANDA (TIDAK DIUBAH SAMA SEKALI)
  // ===========================================================================

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 120),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xfff5f7ff),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xff7b88ff),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          "Tidak ada tagihan perkuliahan",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Yeay, saat ini Anda belum memiliki tagihan perkuliahan yang harus dibayarkan.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagihanList() {
    final item = tagihan.first;
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.namaTagihan,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Checkbox(
                  value: item.selected,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: const Color(0xFF0052CC),
                  onChanged: (v) {
                    setState(() {
                      item.selected = v!;
                    });
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jatuh Tempo",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.jatuhTempo,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Rp. ${formatRupiah(item.nominal)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomKosong() {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xffeeeeee)),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "-",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Bayar Tagihan"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBayar() {
    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFEAEAEA),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Bayar",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Rp. ${formatRupiah(totalBayar)}",
                    style: const TextStyle(
                      color: Color(0xFFFF5B1A),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: totalBayar > 0
                    ? () {
                        _showPembayaranDialog();
                      }
                    : null,
                icon: Icon(
                  Icons.check,
                  size: 16,
                  color: totalBayar > 0 ? Colors.white : Colors.grey.shade500,
                ),
                label: Text(
                  "Bayar Tagihan",
                  style: TextStyle(
                    fontSize: 13,
                    color: totalBayar > 0 ? Colors.white : Colors.grey.shade500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: totalBayar > 0
                      ? const Color(0xFF0052CC)
                      : const Color(0xFFE0E0E0),
                  disabledBackgroundColor: const Color(0xFFE0E0E0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPembayaranDialog() {
    final item = tagihan.first;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE5E5E5),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pembayaran",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Pembayaran ${item.namaTagihan}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Informasi Tagihan",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  "Jenis Tagihan",
                  item.namaTagihan,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  "Semester",
                  "Genap 2026/2027",
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  "Jatuh Tempo",
                  item.jatuhTempo,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  "Total Pembayaran",
                  "Rp. ${formatRupiah(item.nominal)}",
                  valueColor: const Color(0xFF0052CC),
                  bold: true,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Status Pembayaran",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Pembayaran dilakukan di loket Akademik secara manual",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0052CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Tutup",
                      style: TextStyle(
                        color: Colors.white,
                      ),
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

  Widget _buildInfoRow(
    String title,
    String value, {
    Color valueColor = Colors.black,
    bool bold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              color: valueColor,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAMBAHAN KODE BARU UNTUK TAB RIWAYAT PEMBAYARAN
  // ===========================================================================

  Widget _buildEmptyStateRiwayat() {
    return Column(
      children: [
        const SizedBox(height: 120),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xfff5f7ff),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xff7b88ff),
              child: Icon(
                Icons.history,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          "Belum ada riwayat",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Anda belum memiliki riwayat pembayaran tagihan perkuliahan.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiwayatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: riwayat.length,
      itemBuilder: (context, index) {
        final item = riwayat[index];
        return InkWell(
          onTap: () => _showDetailRiwayatDialog(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // Radius disesuaikan agar lebih halus
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Agar sejajar di tengah vertikal
              children: [
                // Ikon Struk (Kiri)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9), // Background hijau muda
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: Color(0xFF43A047), // Ikon hijau tua
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info Teks (Tengah) - Dibungkus Expanded agar tidak menabrak harga
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaTagihan,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1, // Batasi 1 baris
                        overflow: TextOverflow.ellipsis, // Tambahkan ... jika teks kepanjangan
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // Mengambil tanggal saja (contoh: "14 Juni 2026")
                        item.waktuKonfirmasi.split(' ').take(3).join(' '), 
                        style: const TextStyle(
                          color: Colors.grey, 
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12), // Jarak aman antara teks dan harga
                
                // Harga (Kanan)
                Text(
                  "Rp. ${formatRupiah(item.nominal)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14, 
                    color: Color(0xFF0052CC), // Warna biru sesuai desain
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetailRiwayatDialog(RiwayatModel item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detail Riwayat Pembayaran",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Pembayaran ${item.namaTagihan} Semester ${item.semester}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Informasi Tagihan",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  "Jenis Tagihan",
                  item.namaTagihan,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  "Semester",
                  item.semester,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  "Total Tagihan",
                  "Rp. ${formatRupiah(item.nominal)}",
                  valueColor: const Color(0xFF0052CC),
                  bold: true,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Status Pembayaran",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                
                // --- KOTAK STATUS HIJAU (Sesuai Gambar) ---
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5), // Hijau sangat muda
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF10B981), width: 1), // Border hijau
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Color(0xFF10B981), // Icon hijau
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Pembayaran telah berhasil dikonfirmasi pada ${item.waktuKonfirmasi}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0052CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Tutup",
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
}