// Lokasi: lib/models/pengaturan_akun_model.dart

class PengaturanAkunModel {
  final String namaLengkap;
  final String username;
  final String email;
  final String nomorTelepon;
  final String role;
  final String inisial;
  final bool isTwoFactorEnabled; // TAMBAHAN UNTUK TAB KEAMANAN

  PengaturanAkunModel({
    required this.namaLengkap,
    required this.username,
    required this.email,
    required this.nomorTelepon,
    required this.role,
    required this.inisial,
    required this.isTwoFactorEnabled, // TAMBAHAN
  });
}