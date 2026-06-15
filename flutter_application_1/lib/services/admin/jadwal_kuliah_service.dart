import 'package:flutter_application_1/models/admin/jadwal_kuliah_model.dart';

class JadwalKuliahService {
  Future<List<JadwalKelasModel>> getJadwalKelas() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      JadwalKelasModel(idKelas: "AK01", namaKelas: "AK-2A", programStudi: "Akuntansi", jumlahMahasiswa: 27),
      JadwalKelasModel(idKelas: "MI01", namaKelas: "MI-2A", programStudi: "Manajemen Informatika", jumlahMahasiswa: 25),
      JadwalKelasModel(idKelas: "TI01", namaKelas: "TI-4C", programStudi: "Teknik Informatika", jumlahMahasiswa: 25),
      JadwalKelasModel(idKelas: "TL01", namaKelas: "TL-2B", programStudi: "Teknik Listrik", jumlahMahasiswa: 23),
      // --- Tambahan data dummy agar tombol 'Lainnya' muncul ---
      JadwalKelasModel(idKelas: "AB01", namaKelas: "AB-1A", programStudi: "Administrasi Bisnis", jumlahMahasiswa: 30),
      JadwalKelasModel(idKelas: "TM01", namaKelas: "TM-3B", programStudi: "Teknik Mesin", jumlahMahasiswa: 22),
    ];
  }
}