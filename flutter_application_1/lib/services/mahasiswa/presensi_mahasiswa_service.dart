// Lokasi: lib/services/presensi_service.dart
import 'package:flutter_application_1/models/mahasiswa/presensi_mahasiswa_model.dart';

class PresensiMahasiswaService {
  // Simulasi mengambil data detail presensi dari server
  Future<PresensiMahasiswaModel> getDetailPresensiMahasiswa() async {
    await Future.delayed(const Duration(seconds: 1)); // Loading buatan 1 detik
    
    return PresensiMahasiswaModel(
      statusSesi: "Menunggu Sesi dimulai",
      namaMatkul: "PBL-1 (PRAKTIKUM)",
      lokasi: "Offline - Lab. Komputer\nRekayasa 1",
      kelas: "4C",
      waktu: "08:00 - 10:45",
      deskripsiSesi: "Sesi 15 | Mahasiswa mampu merealisasikan...",
      namaDosen: "Nur Zannah, S.Kom., M.Kom",
      statusPresensi: "Belum Mengisi Presensi",
    );
  }

  // Simulasi mengirim kode presensi ke server
  Future<bool> submitPresensiMahasiswa(String kode) async {
    await Future.delayed(const Duration(seconds: 1)); 
    // Anggap saja kode presensi yang benar dari dosen adalah "123456"
    if (kode == "123456") {
      return true; // Berhasil
    }
    return false; // Gagal / Kode salah
  }
}