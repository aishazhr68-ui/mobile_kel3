import 'package:flutter_application_1/models/mahasiswa/dashboard_mahasiswa_model.dart';

class DashboardMahasiswaService {
  Future<DashboardMahasiswaModel> getDashboardData() async {
    // Simulasi loading 1 detik
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy sesuai dengan gambar
    return DashboardMahasiswaModel(
      studentInfo: StudentInfoModel(
        nama: "Aufa Qonita Salsabila",
        nim: "C030324011",
        prodi: "D3 Teknik Informatika", // Sesuai gambar
        ipk: 3.80,
        totalSks: 84,
        semesterAktif: "Semester Ganjil 2024/2025",
      ),
      jadwalHariIni: [
        JadwalHariIniModel(
          namaMatkul: "Pemrograman Web",
          waktu: "08.00 - 12.10",
          ruang: "L. RPL",
          namaDosen: "Agus S. B. N., S. T., M. Kom.",
        ),
        JadwalHariIniModel(
          namaMatkul: "Keamanan Jaringan",
          waktu: "13.30 - 16.00",
          ruang: "L. JARINGAN",
          namaDosen: "Dr. Kun N. P. P., S. T., M.Kom.",
        ),
      ],
    );
  }
}