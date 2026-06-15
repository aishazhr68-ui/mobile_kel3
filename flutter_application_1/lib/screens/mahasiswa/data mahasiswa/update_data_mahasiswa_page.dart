// Lokasi: lib/screens/pages/mahasiswa/update_data_mahasiswa_page.dart
import 'package:flutter/material.dart';

class UpdateDataMahasiswaPage extends StatefulWidget {
  const UpdateDataMahasiswaPage({super.key});

  @override
  State<UpdateDataMahasiswaPage> createState() => _UpdateDataMahasiswaPageState();
}

class _UpdateDataMahasiswaPageState extends State<UpdateDataMahasiswaPage> with SingleTickerProviderStateMixin {
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
                Text("Update Data Mahasiswa", style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
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
                                decoration: const BoxDecoration(color: Color(0xFFE0E7FF), shape: BoxShape.circle),
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
                                          child: const Text("AKTIF", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
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

                  // =========================================================
                  // PERBAIKAN: Form Dinamis berdasarkan Tab yang dipilih
                  // =========================================================
                  AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, child) {
                      switch (_tabController.index) {
                        case 0: return _buildFormIdentitas();
                        case 1: return _buildFormDomisili();
                        case 2: return _buildFormOrangTua();
                        case 3: return _buildFormSekolah();
                        default: return const SizedBox.shrink();
                      }
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tombol Batal & Simpan (Berada di luar switch agar selalu ada di setiap tab)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text("Batal", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D4ED8),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
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

  // --- WIDGET HELPER UMUM ---

  Widget _buildProfileRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        Text(value, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField(String label, String initialValue, {bool isRequired = false, bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              children: isRequired ? [const TextSpan(text: " *", style: TextStyle(color: Colors.red))] : [],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialValue,
            readOnly: isReadOnly,
            style: TextStyle(fontSize: 14, color: isReadOnly ? const Color(0xFF94A3B8) : const Color(0xFF1E293B)),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              filled: true,
              fillColor: isReadOnly ? const Color(0xFFF1F5F9) : Colors.white, 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              children: isRequired ? [const TextSpan(text: " *", style: TextStyle(color: Colors.red))] : [],
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            hint: value.isEmpty ? const Text("Pilih...", style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8))) : null,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              filled: true,
              fillColor: Colors.white,
            ),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, String value, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              children: isRequired ? [const TextSpan(text: " *", style: TextStyle(color: Colors.red))] : [],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
                const Icon(Icons.calendar_today, color: Color(0xFF64748B), size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeaderDataKeluarga(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Color(0xFF1D4ED8), size: 18),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
        ],
      ),
    );
  }

  // --- KONTEN FORM BERDASARKAN TAB ---

  Widget _buildFormIdentitas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Data Identitas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        _buildTextField("NIM", "A020325112", isRequired: true, isReadOnly: true),
        _buildTextField("Nama Lengkap", "Andi Pratama", isRequired: true, isReadOnly: true),
        _buildDatePicker("Tanggal Lahir", "01/01/2000", isRequired: true),
        _buildDropdown("Jenis Kelamin", ["Laki-laki", "Perempuan"], "Laki-laki", isRequired: true),
        _buildTextField("No. HP", "0813-0000-2314", isRequired: true),
        _buildTextField("Email", "andipratama@gmail.com", isRequired: true),
        _buildDropdown("Agama", ["Islam", "Kristen", "Katolik", "Hindu", "Buddha"], "Islam", isRequired: true),
        _buildTextField("Status Mahasiswa", "Aktif", isRequired: true, isReadOnly: true),
      ],
    );
  }

  Widget _buildFormDomisili() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Domisili", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        _buildTextField("Alamat", "Jl. Sultan Adam Komp.Mahligai", isRequired: true),
        _buildTextField("Provinsi", "Kalimantan Selatan", isRequired: true),
        _buildTextField("Kabupaten/Kota", "Kota Banjarmasin", isRequired: true),
        _buildTextField("Kecamatan", "Banjarmasin Utara", isRequired: true),
        _buildTextField("Kelurahan/Desa", "Sungai Jinggah", isRequired: true),
        _buildTextField("Kode Pos", "70121", isRequired: true),
      ],
    );
  }

  Widget _buildFormOrangTua() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Orang Tua/Wali", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),

        // --- DATA AYAH ---
        _buildSectionHeaderDataKeluarga("Data Ayah"),
        _buildTextField("Nama Ayah", "Slamet Riyadi", isRequired: true),
        _buildDropdown("Pekerjaan Ayah", ["Karyawan Swasta", "PNS", "Wiraswasta", "Buruh", "Lainnya"], "Karyawan Swasta", isRequired: true),
        _buildTextField("No. Hp Ayah", "0812-3422-2100", isRequired: true),
        _buildDropdown("Penghasilan Ayah", ["≤ Rp 1.000.000", "Rp 1.000.000 - Rp 3.000.000", "Rp 3.000.000 - Rp 6.000.000", "Rp 6.000.000 - Rp 8.000.000", "≥ Rp 8.000.000"], "Rp 6.000.000 - Rp 8.000.000", isRequired: true),

        const Divider(height: 32, color: Color(0xFFF1F5F9), thickness: 2),

        // --- DATA IBU ---
        _buildSectionHeaderDataKeluarga("Data Ibu"),
        _buildTextField("Nama Ibu", "Fitriyani", isRequired: true),
        _buildDropdown("Pekerjaan Ibu", ["Ibu Rumah Tangga", "Karyawan Swasta", "PNS", "Wiraswasta", "Lainnya"], "Ibu Rumah Tangga", isRequired: true),
        _buildTextField("No. Hp Ibu", "0813-2120-0908", isRequired: true),
        _buildDropdown("Penghasilan Ibu", ["≤ Rp 1.000.000", "Rp 1.000.000 - Rp 3.000.000", "Rp 3.000.000 - Rp 6.000.000", "Rp 6.000.000 - Rp 8.000.000", "≥ Rp 8.000.000"], "≤ Rp 1.000.000", isRequired: true),

        const Divider(height: 32, color: Color(0xFFF1F5F9), thickness: 2),

        // --- DATA WALI ---
        _buildSectionHeaderDataKeluarga("Data Wali"),
        _buildTextField("Nama Wali", "", isRequired: false), // Kosong sesuai desain
        _buildDropdown("Pekerjaan Wali", ["Pilih Pekerjaan Wali", "Karyawan Swasta", "PNS", "Wiraswasta", "Lainnya"], "Pilih Pekerjaan Wali", isRequired: false),
        _buildTextField("No. Hp Wali", "", isRequired: false),
        _buildDropdown("Penghasilan Wali", ["Pilih Penghasilan Wali", "≤ Rp 1.000.000", "Rp 1.000.000 - Rp 3.000.000", "Rp 3.000.000 - Rp 6.000.000", "Rp 6.000.000 - Rp 8.000.000", "≥ Rp 8.000.000"], "Pilih Penghasilan Wali", isRequired: false),
      ],
    );
  }

  Widget _buildFormSekolah() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pada desain mockupmu ada sedikit typo di judul "Orang Tua/Wali" padahal isinya sekolah, 
        // tapi secara logika aplikasi ini adalah form Data Sekolah.
        const Text("Data Sekolah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),

        _buildDropdown("Jenis Sekolah", ["SMA", "SMK", "MA", "Lainnya"], "SMA", isRequired: true),
        _buildTextField("Sekolah", "30304271 - SMA Negeri 5 Banjarmasin", isRequired: true),
        _buildTextField("Provinsi Sekolah", "Kalimantan Selatan", isRequired: true),
        _buildTextField("Kota Sekolah", "Kota Banjarmasin", isRequired: true),
        _buildTextField("Alamat Sekolah", "Jl. Sultan Adam No.76, Surgi Mufti", isRequired: true),
      ],
    );  
  }
}