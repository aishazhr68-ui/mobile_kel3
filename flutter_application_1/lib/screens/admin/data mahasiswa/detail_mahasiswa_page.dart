import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/models/admin/mahasiswa_model.dart';
import '../../../services/admin/mahasiswa_service.dart';

class DetailMahasiswaPage extends StatefulWidget {
  final MahasiswaModel mahasiswa; // Menerima data dari halaman list

  const DetailMahasiswaPage({super.key, required this.mahasiswa});

  @override
  State<DetailMahasiswaPage> createState() => _DetailMahasiswaPageState();
}

class _DetailMahasiswaPageState extends State<DetailMahasiswaPage> {
  int selectedTab = 0;
  
  // 🔥 Variabel State dipindahkan ke SINI (di dalam State Class)
  MahasiswaModel? detailData; 
  bool isLoading = true;
  final MahasiswaService _mahasiswaService = MahasiswaService();

  @override
  void initState() {
    super.initState();
    fetchDetailData();
  }

  Future<void> fetchDetailData() async {
    try {
      // Mengambil data berdasarkan NIM dari widget (mahasiswa yang dipilih)
      // Catatan: Jika API Anda belum siap, Anda bisa sementara menggunakan widget.mahasiswa
      final data = await _mahasiswaService.getDetailMahasiswa(widget.mahasiswa.nim);
      
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
    // Tampilkan loading saat API sedang berjalan
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Gunakan data dari detailData (API) atau widget.mahasiswa (fallback)
    final mhs = detailData ?? widget.mahasiswa;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      extendBody: true, // 🔥 Biar FAB menyatu dengan lengkungan navbar

      // ================= FLOAT BUTTON =================
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFAB(), // 🔥 Panggil CustomFAB

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const CustomBottomNavBar(), // 🔥 Panggil CustomBottomNavBar

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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120), // Padding bawah agar konten tidak tertutup nav
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
                    color: Colors.black.withValues(alpha: 0.06),
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
                                Text(
                                  mhs.nama, 
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                ),
                                // Container Status Dinamis
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    // Pengecekan warna background langsung di dalam widget
                                    color: mhs.status == "AKTIF" ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    mhs.status.toUpperCase(),
                                    style: TextStyle(
                                      // Pengecekan warna teks langsung di dalam widget
                                      color: mhs.status == "AKTIF" ? const Color(0xFF16A34A) : Colors.red,
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
                  _profileDetailRow("Program Studi", "D3 Teknik Pertambangan"),
                  const SizedBox(height: 12),
                  _profileDetailRow("Tahun Akademik", "2025/2026"),
                  const SizedBox(height: 12),
                  _profileDetailRow("Kelas", "TP-2C"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= TAB =================
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
            _buildTabContent(),
            const SizedBox(height: 20),
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

  // Helper Widget Tab & Content (sama seperti kode Anda sebelumnya)
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
  

  // ================= CONTENT =================
Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return Column( // 🔥 PASTIKAN ADA 'return'
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Identitas", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _dataBox("NIM", "A020325112"),
            _dataBox("NAMA LENGKAP", "Andi Pratama"),
            _dataBox("JENIS KELAMIN", "Laki-laki"),
            _dataBox("TANGGAL LAHIR", "17-05-2007"),
            _dataBox("AGAMA", "Islam"),
            _dataBox("EMAIL", "andipratama@gmail.com"),
            _dataBox("NO HP", "0813-0000-2314"),
            _dataBox("STATUS MAHASISWA", "Aktif", isGreen: true),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Domisili",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _dataBox("ALAMAT", "Jl. Sultan Adam Komp. Mahligai"),
            _dataBox("RT / RW", "20 / 01"),
            _dataBox("NO", "102"),
            _dataBox("PROVINSI", "Kalimantan Selatan"),
            _dataBox("KABUPATEN/KOTA", "Kota Banjarmasin"),
            _dataBox("KECAMATAN", "Banjarmasin Utara"),
            _dataBox("KELURAHAN/DESA", "Sungai Jingah"),
            _dataBox("KODE POS", "70121"),
            _dataBox("STATUS TINGGAL", "Rumah Orang Tua"),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Data Orang Tua",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _parentCard(
              "NAMA AYAH",
              "Slamet Riyadi",
              "Karyawan Swasta",
              "0812-3422-2100",
              "Rp6.000.000 – Rp 8.000.000",
            ),
            _parentCard(
              "NAMA IBU",
              "Fitriyani",
              "Ibu Rumah Tangga",
              "0813-2120-0908",
              "≤ Rp1.000.000",
            ),
            _parentCard(
              "NAMA WALI",
              "-",
              "-",
              "-",
              "-",
            ),
       _parentCard(
              "NAMA WALI",
              "-",
              "-",
              "-",
              "-",
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Data Sekolah",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _schoolCard(),
            _alamatSekolahCard(),
            _ijazahCard(),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  // ================= MISSING WIDGETS ADDED & IMPR0VED =================

  Widget _dataBoxSimple(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A), // Hitam
          ),
        ),
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
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color:
                  isGreen ? const Color(0xFF16A34A) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 WIDGET BARU UNTUK CARD PROFIL (RATA KANAN-KIRI TANPA TITIK DUA)
  Widget _profileDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _parentCard(String label, String nama, String pekerjaan, String hp,
      String penghasilan) {
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
          Text(label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
              )),
          const SizedBox(height: 6),
          Text(nama,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              )),
          const SizedBox(height: 10),
          const Text("PEKERJAAN",
              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          Text(
            pekerjaan,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "NO. HP",
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
          Text(
            hp,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "PENGHASILAN",
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
          Text(
            penghasilan,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _schoolCard() {
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
          // 🔹 Tambahkan Jenis Sekolah (Rata Kiri Kolom)
          _dataBoxSimple("Jenis Sekolah", "SMA"),

          // 🔹 Sekolah (LABEL + LINK STYLE, Rata Kiri Kolom)
          const Text(
            "Sekolah",
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8), // abu label
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "30304271 - SMA Negeri 5 Banjarmasin",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue, // 🔥 tetap biru
            ),
          ),
          const SizedBox(height: 10),

          // 🔹 Layout Dua Kolom Baru (Masing-masing Rata Kiri)
          Row(
            children: [
              // Kolom 1
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "No Ijazah Sekolah",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "0000011",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A), // hitam
                      ),
                    ),
                  ],
                ),
              ),
              // Kolom 2
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "NISN",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "0078349391",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _alamatSekolahCard() {
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
          // 🔹 TITLE + ICON (Rata Kiri Kolom)
          Row(
            children: const [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                "Alamat Sekolah",
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 🔹 VALUE ALAMAT (Rata Kiri Kolom)
          const Text(
            "Jl. Sultan Adam No.76, Surgi Mufti",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          // 🔹 Layout Dua Kolom Baru (Masing-masing Rata Kiri)
          Row(
            children: [
              // Kolom 1
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Provinsi",
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Kalimantan Selatan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              // Kolom 2
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Kota",
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Kota Banjarmasin",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ijazahCard() {
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
          Row(
            children: const [
              Icon(Icons.description_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                "File Ijazah Terakhir",
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Belum Diunggah",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}