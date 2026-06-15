class KhsInfoModel {
  final String nama;
  final String nim;
  final String prodi;
  final String kelas;
  final String dosenWali;
  final String status;
  final double ipSemester;
  final double ipKumulatif;

  KhsInfoModel({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.kelas,
    required this.dosenWali,
    required this.status,
    required this.ipSemester,
    required this.ipKumulatif,
  });
}

class KhsMatkulModel {
  final String nama;
  final String kode;
  final int sks;
  final String nilaiHuruf;
  final String nilaiAngka;

  KhsMatkulModel({
    required this.nama,
    required this.kode,
    required this.sks,
    required this.nilaiHuruf,
    required this.nilaiAngka,
  });
}