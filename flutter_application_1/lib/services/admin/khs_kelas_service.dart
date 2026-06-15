import 'package:flutter_application_1/models/admin/khs_kelas_model.dart'; // Sesuaikan path

class KhsKelasService {
  // Simulasi pemanggilan API (menggunakan Future)
  Future<List<StudentKhs>> gettKhsKelas(String idKelas) async {
    // Simulasi loading/delay dari server selama 1 detik
    await Future.delayed(const Duration(seconds: 1));

    // Nantinya bagian ini diganti dengan response dari API (misal menggunakan package http/dio)
    return [
      StudentKhs(nim: "C030324003", name: "Ahmad Ridho Kurniawan", IPK: 3.62, status: "Lulus"),
      StudentKhs(nim: "C030324007", name: "Alfyan Losong", IPK: 2.45, status: "Perbaikan"),
      StudentKhs(nim: "C030324011", name: "Aufa Qonita Salsabila", IPK: 3.48, status: "Lulus"),
      StudentKhs(nim: "C030324015", name: "Denys Kenan Dau", IPK: 3.10, status: "Lulus"),
      StudentKhs(nim: "C030324019", name: "Ghina Dwi Putri Dahliana", IPK: 3.75, status: "Lulus"),
      StudentKhs(nim: "C030324023", name: "Linggar Anugerah Wijaya", IPK: 2.90, status: "Lulus"),
    ];
  }
}