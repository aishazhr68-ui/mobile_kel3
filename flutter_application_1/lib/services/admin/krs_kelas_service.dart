import 'package:flutter_application_1/models/admin/krs_kelas_model.dart'; // Sesuaikan path

class KrsKelasService {
  // Simulasi pemanggilan API (menggunakan Future)
  Future<List<StudentKrs>> gettKrsKelas(String idKelas) async {
    // Simulasi loading/delay dari server selama 1 detik
    await Future.delayed(const Duration(seconds: 1));

    // Nantinya bagian ini diganti dengan response dari API (misal menggunakan package http/dio)
    return [
      StudentKrs(nim: "C030324003", name: "Ahmad Ridho Kurniawan", sks: 18, status: "Disetujui"),
      StudentKrs(nim: "C030324007", name: "Alfyan Losong", sks: 18, status: "Belum Disetujui"),
      StudentKrs(nim: "C030324011", name: "Aufa Qonita Salsabila", sks: 18, status: "Disetujui"),
      StudentKrs(nim: "C030324015", name: "Denys Kenan Dau", sks: 18, status: "Disetujui"),
      StudentKrs(nim: "C030324019", name: "Ghina Dwi Putri Dahliana", sks: 18, status: "Disetujui"),
      StudentKrs(nim: "C030324023", name: "Linggar Anugerah Wijaya", sks: 18, status: "Disetujui"),
    ];
  }
}