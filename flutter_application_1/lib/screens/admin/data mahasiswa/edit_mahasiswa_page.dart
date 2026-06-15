import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/models/admin/mahasiswa_model.dart';
import '../../../services/admin/mahasiswa_service.dart';

class EditMahasiswaPage extends StatefulWidget {
  final MahasiswaModel mahasiswa;
  const EditMahasiswaPage({super.key, required this.mahasiswa});

  @override
  State<EditMahasiswaPage> createState() => _editmahasiswapage();
}

class _editmahasiswapage extends State<EditMahasiswaPage> {
  int selectedTab = 0;

  MahasiswaModel? editData;
  bool isLoading = true;
  final MahasiswaService _mahasiswaService = MahasiswaService();

  @override
  void initState() {
    super.initState();
    // 🔥 3. Panggil data detail agar form terisi otomatis
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await _mahasiswaService.getDetailMahasiswa(widget.mahasiswa.nim);
      if (mounted) {
        setState(() {
          editData = data;
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
    final mhs = editData ?? widget.mahasiswa;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      extendBody: true, // 🔥 Biar FAB menyatu dengan lengkungan navbar

      // ================= FLOAT BUTTON =================
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFAB(), // 🔥 Panggil CustomFAB

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const CustomBottomNavBar(),

      // ================= BODY =================
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "Data Mahasiswa",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              "Update Data Mahasiswa", // 🔥 DIUBAH
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
                        child: const Icon(Icons.person,
                            color: Color(0xFF2563EB), size: 30),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Andi Pratama",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "AKTIF",
                                    style: TextStyle(
                                      color: Color(0xFF16A34A),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "NIM: A020325112",
                              style: TextStyle(color: Colors.grey),
                            ),
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

            const SizedBox(height: 24),
            
            // ================= ACTION BUTTONS (Batal & Simpan) =================
            _buildActionButtons(),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ================= TAB =================
  Widget _tabItem(String title, int index) {
    bool active = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: active ? Colors.blue : Colors.grey,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 5),
            if (active)
              Container(
                width: 40,
                height: 2,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  // ================= CONTENT FORM =================
  Widget _buildTabContent() {
    switch (selectedTab) {
      // ---------------- TAB 0: IDENTITAS ----------------
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Data Identitas",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 16),
            _buildTextField("NIM", "A020325112", isRequired: true),
            _buildTextField("Nama Lengkap", "Andi Pratama", isRequired: true),
            _buildTextField("Tanggal Lahir", "01/01/2000", isRequired: true, suffixIcon: Icons.calendar_today_outlined),
            _buildDropdown("Jenis Kelamin", "Laki-laki", ["Laki-laki", "Perempuan"], isRequired: true),
            _buildTextField("No. Hp", "0813-0000-2314", isRequired: true),
            _buildTextField("Email", "andipratama@gmail.com", isRequired: true),
            _buildDropdown("Agama", "Islam", ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Konghucu"], isRequired: true),
            _buildDropdown("Status Mahasiswa", "Aktif", ["Aktif", "Cuti", "Lulus"], isRequired: true),
          ],
        );

      // ---------------- TAB 1: DOMISILI ----------------
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Domisili",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 16),
            _buildTextField("Alamat", "Jl. Sultan Adam Komp. Mahligai", isRequired: true),
            Row(
              children: [
                Expanded(child: _buildTextField("RT", "20", isRequired: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField("RW", "01", isRequired: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField("No", "102", isRequired: true)),
              ],
            ),
            _buildTextField("Provinsi", "Kalimantan Selatan", isRequired: true),
            _buildTextField("Kabupaten/Kota", "Kota Banjarmasin", isRequired: true),
            _buildTextField("Kecamatan", "Banjarmasin Utara", isRequired: true),
            _buildTextField("Kelurahan/Desa", "Sungai Jingah", isRequired: true),
            _buildTextField("Kode Pos", "70121", isRequired: true),
            _buildDropdown("Status Tinggal", "Rumah Orang Tua", ["Rumah Orang Tua", "Kost", "Asrama"], isRequired: true),
          ],
        );

      // ---------------- TAB 2: ORANG TUA/WALI ----------------
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Orang Tua/Wali",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 16),
            
            // Ayah
            _buildSectionHeader("Data Ayah"),
            _buildTextField("Nama Ayah", "Slamet Riyadi", isRequired: true),
            _buildDropdown("Pekerjaan Ayah", "Karyawan Swasta", ["Karyawan Swasta", "Wiraswasta", "PNS", "Lainnya"], isRequired: true),
            _buildTextField("No. Hp Ayah", "0812-3422-2100", isRequired: true),
            _buildDropdown("Penghasilan Ayah", "Rp 6.000.000 - Rp 8.000.000", ["≤ Rp 1.000.000", "Rp 1.000.000 - Rp 3.000.000", "Rp 3.000.000 - Rp 6.000.000", "Rp 6.000.000 - Rp 8.000.000", "≥ Rp 8.000.000"], isRequired: true),

            const SizedBox(height: 8),

            // Ibu
            _buildSectionHeader("Data Ibu"),
            _buildTextField("Nama Ibu", "Fitriyani", isRequired: true),
            _buildDropdown("Pekerjaan Ibu", "Ibu Rumah Tangga", ["Ibu Rumah Tangga", "Karyawan Swasta", "Wiraswasta", "Lainnya"], isRequired: true),
            _buildTextField("No. Hp Ibu", "0813-2120-0908", isRequired: true),
            _buildDropdown("Penghasilan Ibu", "≤ Rp 1.000.000", ["≤ Rp 1.000.000", "Rp 1.000.000 - Rp 3.000.000", "Rp 3.000.000 - Rp 6.000.000", "≥ Rp 6.000.000"], isRequired: true),

            const SizedBox(height: 8),

            // Wali
            _buildSectionHeader("Data Wali"),
            _buildTextField("Nama Wali", "", isRequired: false),
            _buildDropdown("Pekerjaan Wali", "Pilih Pekerjaan Wali", ["Pilih Pekerjaan Wali", "Karyawan Swasta", "PNS", "Lainnya"], isRequired: false),
            _buildTextField("No. Hp Wali", "", isRequired: false),
            _buildDropdown("Penghasilan Wali", "Pilih Penghasilan Wali", ["Pilih Penghasilan Wali", "≤ Rp 1.000.000", "Rp 1.000.000 - Rp 3.000.000", "≥ Rp 3.000.000"], isRequired: false),
          ],
        );

      // ---------------- TAB 3: SEKOLAH ----------------
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text(
              "Sekolah", // Sesuai dengan gambar tab terakhir
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 16),
            _buildDropdown("Jenis Sekolah", "SMA", ["SMA", "SMK", "MA"], isRequired: true),
            _buildTextField("Sekolah", "30304271 - SMA Negeri 5 Banjarmasin", isRequired: true),
            _buildTextField("Provinsi Sekolah", "Kalimantan Selatan", isRequired: true),
            _buildTextField("Kota Sekolah", "Kota Banjarmasin", isRequired: true),
            _buildTextField("Alamat Sekolah", "Jl. Sultan Adam No.76, Surgi Mufti", isRequired: true),
            _buildTextField("No Ijazah Sekolah", "0000011", isRequired: true),
            _buildTextField("NISN", "0078349391", isRequired: true),
            
            // File Ijazah Upload Field
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("File Ijazah Terakhir", style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text("Pilih File", style: TextStyle(color: Color(0xFF475569))),
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  // ================= FORM HELPER WIDGETS =================

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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Color(0xFF2563EB), size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, {bool isRequired = false, IconData? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              if (isRequired) const Text(" *", style: TextStyle(fontSize: 12, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialValue,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20, color: Colors.grey) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> options, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              if (isRequired) const Text(" *", style: TextStyle(fontSize: 12, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedValue,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
      onPressed: () {
        Navigator.pop(context); // 🔥 biar bisa kembali
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFD1D5DB)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        "Batal",
        style: TextStyle(
          color: Color(0xFF334155),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ),


 const SizedBox(width: 16),

    // 🔹 BUTTON SIMPAN
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          // aksi simpan
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Simpan Perubahan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  ],
);
  }
}
