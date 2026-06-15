// Lokasi: lib/screens/pages/mahasiswa/data_mahasiswa_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';
import 'package:flutter_application_1/screens/mahasiswa/data mahasiswa/update_data_mahasiswa_page.dart';

class DataMahasiswaPage extends StatefulWidget {
  const DataMahasiswaPage({super.key});

  @override
  State<DataMahasiswaPage> createState() => _DataMahasiswaPageState();
}

class _DataMahasiswaPageState extends State<DataMahasiswaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 4 Tab: Identitas, Domisili, Orang Tua/Wali, Sekolah
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const CustomBottomNavMahasiswa(
        currentIndex: 1,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D4ED8)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Kembali", style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 16, fontWeight: FontWeight.bold)),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // Header Teks Top
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Data Mahasiswa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                Text("Detail Data Mahasiswa", style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Tombol Update
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigasi ke halaman Update
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateDataMahasiswaPage()));
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text("Update"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF2994A), // Warna orange sesuai desain
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card Profil & Tabs
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 60, height: 60,
                                decoration: BoxDecoration(color: const Color(0xFFE0E7FF), shape: BoxShape.circle),
                                child: const Icon(Icons.person, size: 40, color: Color(0xFF1D4ED8)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Andi Pratama", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)),
                                          child: const Text("AKTIF", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))), // Hijau
                                        ),
                                      ],
                                    ),
                                    const Text("NIM: A020325112", style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildProfileRow("Program Studi", "D3 Teknik Pertambangan"),
                              const SizedBox(height: 8),
                              _buildProfileRow("Tahun Akademik", "2025/2026"),
                              const SizedBox(height: 8),
                              _buildProfileRow("Kelas", "TP-2C"),
                            ],
                          ),
                        ),
                        // Tabs
                        Container(
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: const Color(0xFF1D4ED8),
                            unselectedLabelColor: const Color(0xFF64748B),
                            indicatorColor: const Color(0xFF1D4ED8),
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            tabs: const [
                              Tab(text: "Identitas"),
                              Tab(text: "Domisili"),
                              Tab(text: "Orang Tua/Wali"),
                              Tab(text: "Sekolah"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // Konten Tab (Menggunakan SizedBox dengan tinggi spesifik atau diletakkan langsung tergantung kebutuhan)
                  // Di sini kita switch isi berdasarkan Tab yang aktif menggunakan Builder & ValueListenable
                  AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, child) {
                      switch (_tabController.index) {
                        case 0: return _buildTabIdentitas();
                        case 1: return _buildTabDomisili();
                        case 2: return _buildTabOrangTua();
                        case 3: return _buildTabSekolah();
                        default: return const SizedBox.shrink();
                      }
                    },
                  ),
                  
                  const SizedBox(height: 40), // Spacer bawah
                  const Center(
                    child: Text(
                      "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildProfileRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        Text(value, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Container Individu (Untuk Identitas & Domisili)
  Widget _buildDataContainer(String label, String value, {Color? valueColor}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Warna background abu-abu kebiruan
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor ?? const Color(0xFF1E293B))),
        ],
      ),
    );
  }

  // --- KONTEN TABS ---

  Widget _buildTabIdentitas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Data Identitas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        _buildDataContainer("NIM", "A020325112"),
        _buildDataContainer("NAMA LENGKAP", "Andi Pratama"),
        _buildDataContainer("JENIS KELAMIN", "Laki-laki"),
        _buildDataContainer("TANGGAL LAHIR", "17-05-2007"),
        _buildDataContainer("AGAMA", "Islam"),
        _buildDataContainer("EMAIL", "andipratama@gmail.com"),
        _buildDataContainer("NO. HP", "0813-0000-2314"),
        _buildDataContainer("STATUS MAHASISWA", "Aktif", valueColor: const Color(0xFF16A34A)), // Teks Hijau
      ],
    );
  }

  Widget _buildTabDomisili() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Domisili", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        _buildDataContainer("ALAMAT", "Jl. Sultan Adam Komp.Mahlighai"),
        _buildDataContainer("PROVINSI", "Kalimantan Selatan"),
        _buildDataContainer("KABUPATEN/KOTA", "Kota Banjarmasin"),
        _buildDataContainer("KECAMATAN", "Banjarmasin Utara"),
        _buildDataContainer("KELURAHAN/DESA", "Sungai Jingah"),
        _buildDataContainer("KODE POS", "70121"),
      ],
    );
  }

  // Container Group (Untuk Orang Tua)
  Widget _buildParentGroupCard(String namaLabel, String namaValue, String pekerjaaan, String noHp, String penghasilan) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(namaLabel.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(namaValue, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          
          Text("PEKERJAAN", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(pekerjaaan, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),

          Text("NO. HP", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(noHp, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))), // Biru
          const SizedBox(height: 12),

          Text("PENGHASILAN", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(penghasilan, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildTabOrangTua() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Data Orang Tua", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        _buildParentGroupCard("NAMA AYAH", "Slamet Riyadi", "Karyawan Swasta", "0812-3422-2100", "Rp 6.000.000 - Rp 8.000.000"),
        _buildParentGroupCard("NAMA IBU", "Fitriyani", "Ibu Rumah Tangga", "0813-2120-0908", "≤ Rp 1.000.000"),
        _buildParentGroupCard("NAMA WALI", "-", "-", "-", "-"),
      ],
    );
  }

  Widget _buildTabSekolah() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Data Sekolah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        
        // Card Asal Sekolah
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Jenis Sekolah", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              const Text("SMA", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 12),
              const Text("Sekolah", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              const Text("30304271 - SMA Negeri 5 Banjarmasin", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
              const SizedBox(height: 12),
                      ],
                    ),
                  ),  

        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), 
            borderRadius: BorderRadius.circular(12), 
            border: Border.all(color: const Color(0xFFE2E8F0))
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 20, color: Color(0xFF64748B)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Kota", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    Text("Kota Banjarmasin", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
],
              ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}