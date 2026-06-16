import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/models/admin/mahasiswa_model.dart';
import '../../../services/admin/mahasiswa_service.dart';

class DetailMahasiswaPage extends StatefulWidget {
  final List<MahasiswaModel> daftarMahasiswa; 
  final int indexAwal;

  const DetailMahasiswaPage({
    super.key, 
    required this.daftarMahasiswa,
    required this.indexAwal,
  });

  @override
  State<DetailMahasiswaPage> createState() => _DetailMahasiswaPageState();
}

class _DetailMahasiswaPageState extends State<DetailMahasiswaPage> {
  int selectedTab = 0;
  
  MahasiswaModel? detailData; 
  bool isLoading = true;
  final MahasiswaService _mahasiswaService = MahasiswaService();

  @override
  void initState() {
    super.initState();
    fetchDetailData();
  }

  // Fungsi untuk memuat data berdasarkan index yang diklik dari halaman sebelumnya
  Future<void> fetchDetailData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final nimAktif = widget.daftarMahasiswa[widget.indexAwal].nim;
      final data = await _mahasiswaService.getDetailMahasiswa(nimAktif);
      print("DEBUG STATUS API DETAIL: ${data.status}");
      
      if (mounted) {
        setState(() {
          detailData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data dasar dari List jika API belum selesai memuat (Fallback)
    final mhs = detailData ?? widget.daftarMahasiswa[widget.indexAwal];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      extendBody: true,

      // ================= FLOAT BUTTON =================
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFAB(),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const CustomBottomNavBar(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: -5,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kembali",
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ================= BODY =================
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)))
        : SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              children: [
                const Text(
                  "Data Mahasiswa",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Detail Data Mahasiswa",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // ================= CARD PROFIL UTAMA =================
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06), 
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFDDE5FF),
                              border: Border.all(
                                color: const Color(0xFF2563EB),
                                width: 2,
                              ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        mhs.nama, 
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  // Gunakan mhs.status.toUpperCase() agar pengecekan konsisten
                                  color: mhs.status.toUpperCase() == "AKTIF" ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  mhs.status.toUpperCase(),
                                  style: TextStyle(
                                    color: mhs.status.toUpperCase() == "AKTIF" ? const Color(0xFF16A34A) : Colors.red,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ],
                                ),
                                const SizedBox(height: 4),
                                Text("NIM: ${mhs.nim}", style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 14),
                      _profileDetailRow("Program Studi", mhs.prodi ?? "D3 Teknik Pertambangan"),
                      const SizedBox(height: 12),
                      _profileDetailRow("Tahun Akademik", mhs.tahunAkademik ?? "2025/2026"),
                      const SizedBox(height: 12),
                      _profileDetailRow("Kelas", mhs.kelas ?? "TP-2C"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ================= TAB SELECTION =================
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _tabItem("Identitas", 0),
                      _tabItem("Domisili", 1),
                      _tabItem("Orang Tua/Wali", 2),
                      _tabItem("Sekolah", 3),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                
                // Konten Tab
                _buildTabContent(mhs), 
                
                const SizedBox(height: 30),
                
                // Footer Copyright
                const Center(
                  child: Text(
                    "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Helper Widget Tab Item
  Widget _tabItem(String title, int index) {
    bool active = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: active ? Colors.blue : Colors.grey, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
            const SizedBox(height: 5),
            if (active) Container(width: 40, height: 2, color: Colors.blue),
          ],
        ),
      ),
    );
  }
  
  // ================= DYNAMIC CONTENT FROM API =================
  Widget _buildTabContent(MahasiswaModel mhs) {
    switch (selectedTab) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Identitas", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _dataBox("NIM", mhs.nim),
            _dataBox("NAMA LENGKAP", mhs.nama),
            _dataBox("JENIS KELAMIN", mhs.jenisKelamin ?? "-"),
            _dataBox("TANGGAL LAHIR", mhs.tanggalLahir ?? "-"),
            _dataBox("AGAMA", mhs.agama ?? "-"),
            _dataBox("EMAIL", mhs.email ?? "-"),
            _dataBox("NO HP", mhs.noHp ?? "-"),
            _dataBox("STATUS MAHASISWA", mhs.status, isGreen: mhs.status.toUpperCase() == "AKTIF"),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Domisili", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            // Mengikuti bagian yang Anda hapus sebelumnya
            _dataBox("ALAMAT", mhs.alamat ?? "-"),
            _dataBox("PROVINSI", mhs.provinsi ?? "-"),
            _dataBox("KABUPATEN/KOTA", mhs.kabupatenKota ?? "-"),
            _dataBox("KECAMATAN", mhs.kecamatan ?? "-"),
            _dataBox("KELURAHAN/DESA", mhs.kelurahanDesa ?? "-"),
            _dataBox("KODE POS", mhs.kodePos ?? "-"),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Orang Tua", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _parentCard(
              "NAMA AYAH",
              mhs.namaAyah ?? "-",
              mhs.pekerjaanAyah ?? "-",
              mhs.noHpAyah ?? "-",
              mhs.penghasilanAyah ?? "-",
            ),
            _parentCard(
              "NAMA IBU",
              mhs.namaIbu ?? "-",
              mhs.pekerjaanIbu ?? "-",
              mhs.noHpIbu ?? "-",
              mhs.penghasilanIbu ?? "-",
            ),
            _parentCard(
              "NAMA WALI",
              mhs.namaWali ?? "-",
              mhs.pekerjaanWali ?? "-",
              mhs.noHpWali ?? "-",
              mhs.penghasilanWali ?? "-",
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Sekolah", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _schoolCard(
              mhs.jenisSekolah ?? "-",
              mhs.namaSekolah ?? "-"), 
            _alamatSekolahCard(
              mhs.kotaSekolah ?? "-"), 
          ],
        );

      default:
        return const SizedBox();
    }
  }

  // ================= MODIFIED WIDGETS =================
  Widget _dataBoxSimple(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _dataBox(String label, String value, {bool isGreen = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isGreen ? const Color(0xFF16A34A) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
        ),
      ],
    );
  }

  Widget _parentCard(String label, String nama, String pekerjaan, String hp, String penghasilan) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          const SizedBox(height: 6),
          Text(nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          const Text("PEKERJAAN", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          Text(pekerjaan, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          const Text("NO. HP", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          Text(hp, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          const Text("PENGHASILAN", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          Text(penghasilan, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  // Definisi diubah agar HANYA menerima 3 parameter (sesuai yang Anda hapus)
Widget _schoolCard(String jenisSekolah, String namaSekolah) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dataBoxSimple("Jenis Sekolah", jenisSekolah),
          const Text("Sekolah", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Text(
            namaSekolah,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          // NISN dan Column-nya sudah dihapus
        ],
      ),
    );
  }

  // Widget _alamatSekolahCard sekarang HANYA menerima 1 parameter (kota)
  Widget _alamatSekolahCard(String kota) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alamat sudah dihapus
          const Text("Kota", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Text(kota, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}