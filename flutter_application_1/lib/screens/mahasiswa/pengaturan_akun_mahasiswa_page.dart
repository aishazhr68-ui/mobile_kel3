// Lokasi: lib/screens/pages/profil/pengaturan_akun_mahasiswa_page.dart
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _isProfileTab = true; // True = Profil, False = Keamanan
  bool _is2FAEnabled = false; // State untuk toggle switch 2FA

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
          // =========================================================
          // 1. BAGIAN HEADER & TABS (DIJADIKAN SATU & DIBERI SHADOW AGAR TETAP DI ATAS)
          // =========================================================
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04), // Efek bayangan halus
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teks Judul
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_isProfileTab ? "Kelola Profil" : "Keamanan Akun", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      Text(_isProfileTab 
                        ? "Update informasi akun dan preferensi Anda di bawah ini." 
                        : "Kelola profil dan preferensi akun Anda", 
                        style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                
                // Tab Switcher
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isProfileTab = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isProfileTab ? const Color(0xFF0D6EFD) : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person, size: 18, color: _isProfileTab ? Colors.white : const Color(0xFF64748B)),
                                  const SizedBox(width: 8),
                                  Text("Profil", style: TextStyle(fontWeight: FontWeight.bold, color: _isProfileTab ? Colors.white : const Color(0xFF64748B))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isProfileTab = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isProfileTab ? const Color(0xFF0D6EFD) : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.security, size: 18, color: !_isProfileTab ? Colors.white : const Color(0xFF64748B)),
                                  const SizedBox(width: 8),
                                  Text("Keamanan", style: TextStyle(fontWeight: FontWeight.bold, color: !_isProfileTab ? Colors.white : const Color(0xFF64748B))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =========================================================
          // 2. BAGIAN KONTEN FORM (BISA DI-SCROLL, AKAN "TENGGELAM" DI BAWAH HEADER)
          // =========================================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Konten Form Dinamis
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: _isProfileTab ? _buildProfileContent() : _buildSecurityContent(),
                  ),

                  const SizedBox(height: 40),
                  
                  // Footer Text
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

  // --- KONTEN TAB PROFIL ---
  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 70, height: 70,
              decoration: const BoxDecoration(color: Color(0xFF0D6EFD), shape: BoxShape.circle),
              child: const Center(child: Text("MH", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EFD),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Upload Foto", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Hapus", style: TextStyle(color: Color(0xFFEF4444))),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(height: 1, color: Color(0xFFE2E8F0)),
        ),
        
        const Text("Informasi Profil", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        const SizedBox(height: 16),
        
        _buildTextField("Nama Lengkap", "Mahasiswa Poliban", isReadOnly: true),
        _buildTextField("Username", "mahasiswa.poliban", isReadOnly: true),
        _buildTextField("Email", "mahasiswa@poliban.ac.id", isReadOnly: true),
        _buildTextField("Nomor Telepon", "081234567890"), 

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D6EFD),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Batal", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- KONTEN TAB KEAMANAN ---
  Widget _buildSecurityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Keamanan Akun", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),

        _buildTextField("Password Lama", "Masukkan password lama", isPassword: true),
        _buildTextField("Password Baru", "Masukkan password baru", isPassword: true),
        _buildTextField("Konfirmasi Password Baru", "Konfirmasi password baru", isPassword: true),

        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined, color: Color(0xFF0D6EFD), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tips Keamanan Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1D4ED8))),
                    const SizedBox(height: 8),
                    _buildTipText("Minimal 8 karakter dengan kombinasi huruf, angka, dan simbol"),
                    _buildTipText("Gunakan password yang unik dan tidak mudah ditebak"),
                    _buildTipText("Jangan gunakan informasi pribadi seperti tanggal lahir"),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Text("Autentikasi Dua Faktor", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Two-Factor Authentication (2FA)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                    SizedBox(height: 4),
                    Text("Tingkatkan keamanan akun dengan 2FA", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Switch(
                value: _is2FAEnabled,
                onChanged: (val) {
                  setState(() { _is2FAEnabled = val; });
                },
                activeColor: const Color(0xFF0D6EFD),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D6EFD),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text("Update Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Batal", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildTextField(String label, String hintOrValue, {bool isReadOnly = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: isPassword ? null : hintOrValue,
            readOnly: isReadOnly,
            obscureText: isPassword,
            style: TextStyle(fontSize: 14, color: isReadOnly ? const Color(0xFF475569) : const Color(0xFF1E293B)),
            decoration: InputDecoration(
              hintText: isPassword ? hintOrValue : null,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              filled: true,
              fillColor: const Color(0xFFF1F5F9), 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF475569), fontSize: 12, height: 1.4))),
        ],
      ),
    );
  }
}