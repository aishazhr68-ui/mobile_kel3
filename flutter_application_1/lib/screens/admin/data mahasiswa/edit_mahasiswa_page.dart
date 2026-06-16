import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/models/admin/mahasiswa_model.dart';
import '../../../services/admin/mahasiswa_service.dart';

class EditMahasiswaPage extends StatefulWidget {
  final MahasiswaModel mahasiswa;
  const EditMahasiswaPage({super.key, required this.mahasiswa});

  @override
  State<EditMahasiswaPage> createState() => _EditMahasiswaPageState();
}

class _EditMahasiswaPageState extends State<EditMahasiswaPage> {
  int selectedTab = 0;

  MahasiswaModel? editData;
  bool isLoading = true;
  final MahasiswaService _mahasiswaService = MahasiswaService();

  @override
  void initState() {
    super.initState();
    // Panggil data detail agar form terisi otomatis dari API
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
      extendBody: true,

      // ================= FLOAT BUTTON =================
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFAB(),

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
              "Update Data Mahasiswa",
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
                                Expanded(
                                  child: Text(
                                    mhs.nama, // 🔥 Nama dinamis
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: mhs.status.toUpperCase() == "AKTIF" ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    mhs.status.toUpperCase(), // 🔥 Status dinamis
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
                            Text(
                              "NIM: ${mhs.nim}", // 🔥 NIM dinamis
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 14),

                  // 🔥 Info dinamis
                  _profileDetailRow("Program Studi", mhs.prodi ?? "Belum diatur"),
                  const SizedBox(height: 12),
                  _profileDetailRow("Tahun Akademik", mhs.tahunAkademik ?? "Belum diatur"),
                  const SizedBox(height: 12),
                  _profileDetailRow("Kelas", mhs.kelas ?? "Belum diatur"),
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

            // Render isi tab yang dinamis
            _buildTabContent(mhs),

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

  // ================= TAB WIDGET =================
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

  // ================= CONTENT FORM (WITH API DATA) =================
  Widget _buildTabContent(MahasiswaModel mhs) {
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
            _buildTextField("NIM", mhs.nim, isRequired: true),
            _buildTextField("Nama Lengkap", mhs.nama, isRequired: true),
            _buildTextField("Tanggal Lahir", mhs.tanggalLahir ?? "", isRequired: true, suffixIcon: Icons.calendar_today_outlined),
            _buildTextField("Jenis Kelamin", mhs.jenisKelamin ?? "", isRequired: true), // Sementara pakai TextField biasa
            _buildTextField("No. Hp", mhs.noHp ?? "", isRequired: true),
            _buildTextField("Email", mhs.email ?? "", isRequired: true),
            _buildTextField("Agama", mhs.agama ?? "", isRequired: true),
            _buildTextField("Status Mahasiswa", mhs.status, isRequired: true),
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
            _buildTextField("Alamat", mhs.alamat ?? "", isRequired: true),
            _buildTextField("Provinsi", mhs.provinsi ?? "", isRequired: true),
            _buildTextField("Kabupaten/Kota", mhs.kabupatenKota ?? "", isRequired: true),
            _buildTextField("Kecamatan", mhs.kecamatan ?? "", isRequired: true),
            _buildTextField("Kelurahan/Desa", mhs.kelurahanDesa ?? "", isRequired: true),
            _buildTextField("Kode Pos", mhs.kodePos ?? "", isRequired: true),
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
            _buildTextField("Nama Ayah", mhs.namaAyah ?? "", isRequired: true),
            _buildTextField("Pekerjaan Ayah", mhs.pekerjaanAyah ?? "", isRequired: true),
            _buildTextField("No. Hp Ayah", mhs.noHpAyah ?? "", isRequired: true),
            _buildTextField("Penghasilan Ayah", mhs.penghasilanAyah ?? "", isRequired: true),

            const SizedBox(height: 8),

            // Ibu
            _buildSectionHeader("Data Ibu"),
            _buildTextField("Nama Ibu", mhs.namaIbu ?? "", isRequired: true),
            _buildTextField("Pekerjaan Ibu", mhs.pekerjaanIbu ?? "", isRequired: true),
            _buildTextField("No. Hp Ibu", mhs.noHpIbu ?? "", isRequired: true),
            _buildTextField("Penghasilan Ibu", mhs.penghasilanIbu ?? "", isRequired: true),

            const SizedBox(height: 8),

            // Wali
            _buildSectionHeader("Data Wali"),
            _buildTextField("Nama Wali", mhs.namaWali ?? "", isRequired: false),
            _buildTextField("Pekerjaan Wali", mhs.pekerjaanWali ?? "", isRequired: false),
            _buildTextField("No. Hp Wali", mhs.noHpWali ?? "", isRequired: false),
            _buildTextField("Penghasilan Wali", mhs.penghasilanWali ?? "", isRequired: false),
          ],
        );

      // ---------------- TAB 3: SEKOLAH ----------------
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text(
              "Sekolah", 
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 16),
            _buildTextField("Jenis Sekolah", mhs.jenisSekolah ?? "", isRequired: true),
            _buildTextField("Sekolah", mhs.namaSekolah ?? "", isRequired: true),
            _buildTextField("Kota Sekolah", mhs.kotaSekolah ?? "", isRequired: true),
            ]
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

  // 🔥 Mengubah parameter menjadi data yang bisa langsung ditampilkan
  Widget _buildTextField(String label, String initialValue, {bool isRequired = false, IconData? suffixIcon}) {
    // Agar form tidak menampilkan string "null" jika data kosong
    final displayValue = initialValue == "null" || initialValue == "-" ? "" : initialValue;
    
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
            initialValue: displayValue, // 🔥 Terisi dari API
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

  // CATATAN: Untuk kemudahan karena value dropdown harus persis dengan isi array 'options',
  // saat ini saya ubah _buildDropdown menjadi _buildTextField agar data dari API (yang string bebas)
  // bisa langsung masuk tanpa menyebabkan error render.
  
  /*
  Widget _buildDropdown(String label, String? selectedValue, List<String> options, {bool isRequired = false}) {
    return Padding(...);
  }
  */

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context); // Batal dan kembali
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
              // aksi simpan update
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