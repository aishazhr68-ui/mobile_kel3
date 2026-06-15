import 'package:flutter_application_1/models/mahasiswa/krs_model.dart';

class KrsService {

  // =========================
  // INFO KRS
  // =========================
  Future<KrsInfoModel> getInfoKrs() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return KrsInfoModel(
      nama: "Aufa Qonita Salsabila",
      nim: "C030324011",
      prodi: "D3 Teknik Informatika",
      kelas: "TI-4C",
      dosenWali: "Herlinawati, S.Ag., M.Pd.",
      
      // TRUE = DISETUJUI
      // FALSE = BELUM DISETUJUI
      isApproved: true,
    );
  }

  // =========================
  // KRS TERSIMPAN
  // =========================
  Future<List<MatkulModel>> getDaftarMatkul() async {
  await Future.delayed(const Duration(milliseconds: 500));

  return [
    MatkulModel(
      kode: "C0302401",
      nama: "Administrasi Database (4C)",
      jadwal: "Rabu, 13:30 - 16:00",
      dosen: "Rahimi Fitri, S.Kom, M.Kom",
      sks: 3,
    ),

    MatkulModel(
      kode: "C0302402",
      nama: "Keamanan Jaringan (4C)",
      jadwal: "Jumat, 08:00 - 12:10",
      dosen: "Dr.Kun N.P.P,S.T, M.Kom",
      sks: 3,
    ),

    MatkulModel(
      kode: "C0302403",
      nama: "Metode Numerik (4C)",
      jadwal: "Kamis, 08:00 - 10:30",
      dosen: "Nitami L.P,S.Kom.M.Kom",
      sks: 2,
    ),

    MatkulModel(
      kode: "C0302404",
      nama: "Pemrograman Perangkat Bergerak (4C)",
      jadwal: "Senin, 14:20 - 19:30",
      dosen: "Arifin Noor A, S. ST, M.T",
      sks: 3,
    ),

    MatkulModel(
      kode: "C0302406",
      nama: "Pemrograman Web (4C)",
      jadwal: "Rabu, 08:00 - 12:10",
      dosen: "Agus S.B.N, S.T., M.Kom",
      sks: 3,
    ),

    MatkulModel(
      kode: "C0302408",
      nama: "Perancangan Perangkat Lunak Berbasis Objek (4C)",
      jadwal: "Senin, 09:40 - 12:10",
      dosen: "Abdul Kadir, Phd",
      sks: 2,
    ),

    MatkulModel(
      kode: "C0302407",
      nama: "Kecerdasan Buatan (4C)",
      jadwal: "Rabu, 13:30 - 16:00",
      dosen: "Yeonie Indrasary",
      sks: 2,
    ),
  ];
}
  // =========================
  // PILIHAN KELAS
  // =========================
  Future<List<PilihanKelasModel>> getPilihanKelas() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      PilihanKelasModel(
        kode: "C0302401",
        nama: "Administrasi Database (4C)",
        jadwal: "Rabu, 13:30 - 16:00",
        sks: 3,
      ),

      PilihanKelasModel(
        kode: "C0302402",
        nama: "Keamanan Jaringan (4C)",
        jadwal: "Jumat, 08:00 - 12:10",
        sks: 3,
      ),

      PilihanKelasModel(
        kode: "C0302407",
        nama: "Kecerdasan Buatan (4C)",
        jadwal: "Jumat, 13:30 - 16:00",
        sks: 2,
      ),

      PilihanKelasModel(
        kode: "C0302403",
        nama: "Metode Numerik (4C)",
        jadwal: "Kamis, 08:00 - 10:00",
        sks: 2,
      ),

      PilihanKelasModel(
        kode: "C0302404",
        nama: "Pemrograman Perangkat Bergerak (4C)",
        jadwal: "Senin, 14:20 - 19:30",
        sks: 3,
      ),

      PilihanKelasModel(
        kode: "C0302406",
        nama: "Pemrograman Web (4C)",
        jadwal: "Rabu, 08:00 - 12:10",
        sks: 3,
      ),

      PilihanKelasModel(
        kode: "C0302408",
        nama: "Perancangan Perangkat Lunak Berbasis Objek (4C)",
        jadwal: "Senin, 09.40 - 12:10",
        sks: 2,
      ),
    ];
  }
}