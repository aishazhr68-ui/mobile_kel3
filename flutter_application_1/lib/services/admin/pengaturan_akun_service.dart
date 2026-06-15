// Lokasi: lib/services/pengaturan_akun_service.dart
import 'package:flutter_application_1/models/admin/pengaturan_akun_model.dart'; // Sesuaikan path

class PengaturanAkunService {
  Future<PengaturanAkunModel> getAkunData() async {
    // Simulasi loading
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data
    return PengaturanAkunModel(
      namaLengkap: "Admin Poliban",
      username: "admin.poliban",
      email: "admin@poliban.ac.id",
      nomorTelepon: "081234567890",
      role: "Administrator",
      inisial: "AD",
      isTwoFactorEnabled: false, // Default 2FA
    );
  }
}