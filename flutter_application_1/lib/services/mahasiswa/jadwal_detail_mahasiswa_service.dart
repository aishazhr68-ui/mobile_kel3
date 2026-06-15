import 'package:flutter_application_1/models/mahasiswa/jadwal_detail_mahasiswa_model.dart';
import 'package:flutter_application_1/models/admin/jadwal_detail_model.dart'; // Sesuaikan path

class JadwalDetailMahasiswaService {
  Future<List<JadwalMataKuliahMahasiswa>> getJadwalDetailMahasiswa(String namaKelas) async {
    // Simulasi loading dari server
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data sesuai gambar
    return [
      JadwalMataKuliahMahasiswa(
        namaMataKuliah: "Pemrograman Perangkat Bergerak",
        sks: 3,
        waktu: "14.20 - 19.30",
        ruang: "BENGKEL RPL",
        namaDosen: "Arifin Noor A, S. ST., M. T.",
      ),
      JadwalMataKuliahMahasiswa(
        namaMataKuliah: "Administrasi Database",
        sks: 3,
        waktu: "13.30 - 17.55",
        ruang: "L. HWK II",
        namaDosen: "Rahimi Fitri, S.Kom, M.Kom",
      ),
      JadwalMataKuliahMahasiswa(
        namaMataKuliah: "Metode Numerik",
        sks: 2,
        waktu: "08.00 - 10.30",
        ruang: "R. KULIAH 2",
        namaDosen: "Nitami L., P., S. Kom. M, Kom.",
      ),
      JadwalMataKuliahMahasiswa(
        namaMataKuliah: "Keamanan Jaringan",
        sks: 3,
        waktu: "08.00 - 12.10",
        ruang: "L. JARINGAN",
        namaDosen: "Dr. Kun N. P. P., S. T., M.Kom.",
      ),
      JadwalMataKuliahMahasiswa(
        namaMataKuliah: "Pemrograman Web",
        sks: 3,
        waktu: "08.00 - 12.10",
        ruang: "L. RPL",
        namaDosen: "Agus S. B. N., S. T., M. Kom.",
      ),
      // Data tambahan agar tombol "Lainnya" muncul
      JadwalMataKuliahMahasiswa(
        namaMataKuliah: "Kecerdasan Buatan",
        sks: 3,
        waktu: "13.30 - 16.00",
        ruang: "L. RPL",
        namaDosen: "Yennie Indrasary",
      ),
    ];
  }
}