// Lokasi: lib/screens/pengaturan_akun_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart'; // Sesuaikan path
import 'package:flutter_application_1/models/admin/pengaturan_akun_model.dart';
import 'package:flutter_application_1/services/admin/pengaturan_akun_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PengaturanAkunPage extends StatefulWidget {
  const PengaturanAkunPage({super.key});

  @override
  State<PengaturanAkunPage> createState() => _PengaturanAkunPageState();
}

class _PengaturanAkunPageState extends State<PengaturanAkunPage> {
  bool isLoading = true;
  PengaturanAkunModel? akunData;
  final PengaturanAkunService _service = PengaturanAkunService();
    
    File? selectedImage;

  final ImagePicker picker = ImagePicker();
  // Tab State (true = Profil, false = Keamanan)
  bool isProfilTabActive = true; 

  // --- Controllers untuk Tab Profil ---
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  // --- Controllers & State untuk Tab Keamanan ---
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool is2FAEnabled = false;



  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> pickImage() async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {
    setState(() {
      selectedImage = File(image.path);
    });
  }
}

  Future<void> _loadData() async {
    try {
      final data = await _service.getAkunData();
      setState(() {
        akunData = data;
        
        // Memasukkan data Profil
        _namaController.text = data.namaLengkap;
        _usernameController.text = data.username;
        _emailController.text = data.email;
        _teleponController.text = data.nomorTelepon;
        _roleController.text = data.role;

        // Memasukkan data Keamanan (2FA)
        is2FAEnabled = data.isTwoFactorEnabled;

        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Gagal memuat data: $e");
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _roleController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leadingWidth: 260,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF1D4ED8)),
            label: const Text(
              "Kembali",
              style: TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER (Teks Berubah Sesuai Tab Aktif)
            Text(
              isProfilTabActive ? "Kelola Profil" : "Keamanan Akun",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isProfilTabActive 
                  ? "Update informasi akun dan preferensi Anda di bawah ini." 
                  : "Kelola profil dan preferensi akun Anda",
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 20),

            // TAB SWITCHER
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // Latar abu-abu
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isProfilTabActive = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isProfilTabActive ? const Color(0xFF1D4ED8) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 16, color: isProfilTabActive ? Colors.white : const Color(0xFF475569)),
                            const SizedBox(width: 6),
                            Text(
                              "Profil",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isProfilTabActive ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isProfilTabActive = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !isProfilTabActive ? const Color(0xFF1D4ED8) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.security, size: 16, color: !isProfilTabActive ? Colors.white : const Color(0xFF475569)),
                            const SizedBox(width: 6),
                            Text(
                              "Keamanan",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: !isProfilTabActive ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // TAMPILKAN FORM SESUAI TAB
            isProfilTabActive ? _buildProfileForm() : _buildSecurityForm(),

            const SizedBox(height: 40),

            // FOOTER
            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, height: 1.5),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. KOMPONEN TAB PROFIL (Desain Sebelumnya)
  // ===========================================================================
  Widget _buildProfileForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
              height: 72,
              width: 72,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xFF1D4ED8),
                shape: BoxShape.circle,
              ),
              child: selectedImage != null
                  ? Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Text(
                        akunData!.inisial,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
              const SizedBox(width: 16),
              
              ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white, // Tambahkan ini
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Text(
                "Upload Foto",
                style: TextStyle(
                  color: Colors.white, // Tambahkan ini
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
              const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedImage = null;
                });
              },
                  style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFECACA)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text("Hapus", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
              ),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(color: Color(0xFFF1F5F9), thickness: 1, height: 1),
          ),
          
          const Text(
            "Informasi Profil",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 16),

          _buildTextInputField(label: "Nama Lengkap", controller: _namaController),
          _buildTextInputField(label: "Username", controller: _usernameController),
          _buildTextInputField(label: "Email", controller: _emailController),
          _buildTextInputField(label: "Nomor Telepon", controller: _teleponController),
          _buildTextInputField(label: "Role", controller: _roleController, isReadOnly: true),
const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profil berhasil diperbarui",
          ),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
    },
    icon: const Icon(
      Icons.save_outlined,
      size: 18,
      color: Colors.white,
    ),
    label: const Text(
      "Simpan Perubahan",
      style: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1D4ED8),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
),

const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Batal", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. KOMPONEN TAB KEAMANAN (Desain Baru)
  // ===========================================================================
  Widget _buildSecurityForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Keamanan Akun",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 16),

          // Input Passwords
          _buildPasswordInputField(label: "Password Lama", hint: "Masukkan password lama", controller: _oldPasswordController),
          _buildPasswordInputField(label: "Password Baru", hint: "Masukkan password baru", controller: _newPasswordController),
          _buildPasswordInputField(label: "Konfirmasi Password Baru", hint: "Konfirmasi password baru", controller: _confirmPasswordController),
          
          // Tips Keamanan Password (Kotak Biru Muda)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF), // Biru sangat pudar
              border: Border.all(color: const Color(0xFFE0F2FE)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Color(0xFF1D4ED8), size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Tips Keamanan Password",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildBulletText("Minimal 8 karakter dengan kombinasi huruf, angka, dan simbol"),
                const SizedBox(height: 4),
                _buildBulletText("Gunakan password yang unik dan tidak mudah ditebak"),
                const SizedBox(height: 4),
                _buildBulletText("Jangan gunakan informasi pribadi seperti tanggal lahir"),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Autentikasi Dua Faktor
          const Text(
            "Autentikasi Dua Faktor",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Two-Factor Authentication (2FA)",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Tingkatkan keamanan akun dengan 2FA",
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: is2FAEnabled,
                  activeColor: const Color(0xFF1D4ED8),
                  onChanged: (value) {
                    setState(() {
                      is2FAEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

// TOMBOL AKSI
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password berhasil diperbarui",
          ),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
    },
    icon: const Icon(
      Icons.sync_lock,
      size: 18,
      color: Colors.white,
    ),
    label: const Text(
      "Update Password",
      style: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1D4ED8),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                _oldPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Batal", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // WIDGET BANTUAN (Helpers)
  // ===========================================================================

  // Helper List Bullet untuk Tips
  Widget _buildBulletText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4, right: 6),
          child: CircleAvatar(backgroundColor: Color(0xFF475569), radius: 2),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
          ),
        ),
      ],
    );
  }

  // Helper Input Teks Biasa (Tab Profil)
  Widget _buildTextInputField({required String label, required TextEditingController controller, bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: isReadOnly,
            style: TextStyle(
              fontSize: 13, 
              fontWeight: FontWeight.w500, 
              color: isReadOnly ? const Color(0xFF64748B) : const Color(0xFF1E293B)
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF1F5F9), 
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1), 
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Input Teks Keamanan (Tab Keamanan - obscure text)
  Widget _buildPasswordInputField({required String label, required String hint, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: true, // Mengubah input menjadi titik-titik (*)
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF1F5F9), 
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}