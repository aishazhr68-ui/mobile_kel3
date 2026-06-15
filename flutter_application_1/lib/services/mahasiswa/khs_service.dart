import 'package:flutter_application_1/models/mahasiswa/khs_model.dart';

class KhsService {
  Future<KhsInfoModel> getInfoKhs() async {
    // Simulasi loading data dari server
    await Future.delayed(const Duration(milliseconds: 300));
    
    return KhsInfoModel(
      nama: "Aufa Qonita Salsabila",
      nim: "C030324011",
      prodi: "D3 Teknik Informatika",
      kelas: "TI-4C",
      dosenWali: "Herlinawati, S.Ag., M.Pd.",
      status: "AKTIF",
      ipSemester: 3.86,
      ipKumulatif: 3.93,
    );
  }

  Future<List<KhsMatkulModel>> getDaftarKhs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      KhsMatkulModel(nama: "Administrasi Database", kode: "C0320401", sks: 3, nilaiHuruf: "A", nilaiAngka: "4.00"),
      KhsMatkulModel(nama: "Keamanan Jaringan", kode: "C0320402", sks: 3, nilaiHuruf: "A", nilaiAngka: "4.00"),
      KhsMatkulModel(nama: "Metode Numerik", kode: "C0320403", sks: 2, nilaiHuruf: "AB", nilaiAngka: "3.50"),
      KhsMatkulModel(nama: "Pemrograman Perangkat Bergerak", kode: "C0320404", sks: 3, nilaiHuruf: "A", nilaiAngka: "4.00"),
      KhsMatkulModel(nama: "Pemrograman Web", kode: "C0320405", sks: 3, nilaiHuruf: "A", nilaiAngka: "4.00"),
      KhsMatkulModel(nama: "Perancangan Perangkat Lunak Berbasis Objek", kode: "C0320406", sks: 2, nilaiHuruf: "A", nilaiAngka: "4.00"),
      KhsMatkulModel(nama: "Kecerdasan Buatan", kode: "C0320407", sks: 2, nilaiHuruf: "A", nilaiAngka: "4.00"),
    ];
  }
}