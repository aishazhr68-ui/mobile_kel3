// Lokasi: lib/services/mahasiswa/presensi_matakuliah_service.dart

import '../../models/mahasiswa/presensi_matakuliah_model.dart';

class PresensiMatakuliahMahasiswaService {
  Future<List<PresensiMatakuliahMahasiswaModel>> getListPresensi() async {
    // Simulasi loading 1 detik seolah mengambil dari API
    await Future.delayed(const Duration(seconds: 1));

   return [
  PresensiMatakuliahMahasiswaModel(
    namaMatkul: "Pemrograman Perangkat Bergerak (4C)",
    sesiHadir: 14,
    totalSesi: 16,
    persentase: 87,
  ),

  PresensiMatakuliahMahasiswaModel(
    namaMatkul: "Keamanan Jaringan (4C)",
    sesiHadir: 12,
    totalSesi: 16,
    persentase: 75,
  ),

  PresensiMatakuliahMahasiswaModel(
    namaMatkul: "Pemrograman Web (4C)",
    sesiHadir: 16,
    totalSesi: 16,
    persentase: 100,
  ),

  PresensiMatakuliahMahasiswaModel(
    namaMatkul: "Metode Numerik (4C)",
    sesiHadir: 10,
    totalSesi: 16,
    persentase: 62,
  ),

  PresensiMatakuliahMahasiswaModel(
    namaMatkul: "Administrasi Database (4C)",
    sesiHadir: 15,
    totalSesi: 16,
    persentase: 93,
  ),

  PresensiMatakuliahMahasiswaModel(
    namaMatkul: "Kecerdasan Buatan (4C)",
    sesiHadir: 13,
    totalSesi: 16,
    persentase: 81,
  ),

  PresensiMatakuliahMahasiswaModel(
    namaMatkul: "Perancangan Perangkat Lunak Berbasis Objek (4C)",
    sesiHadir: 11,
    totalSesi: 16,
    persentase: 68,
  ),
];
  }
}