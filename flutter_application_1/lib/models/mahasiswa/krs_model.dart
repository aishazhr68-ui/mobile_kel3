class KrsInfoModel {
  final String nama;
  final String nim;
  final String prodi;
  final String kelas;
  final String dosenWali;

  // STATUS KRS
  final bool isApproved;

  KrsInfoModel({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.kelas,
    required this.dosenWali,
    required this.isApproved,
  });

  factory KrsInfoModel.fromJson(Map<String, dynamic> json) {
    return KrsInfoModel(
      nama: json['nama'],
      nim: json['nim'],
      prodi: json['prodi'],
      kelas: json['kelas'],
      dosenWali: json['dosen_wali'],
      isApproved: json['is_approved'],
    );
  }
}

class MatkulModel {
  final String kode;
  final String nama;
  final String jadwal;
  final String dosen;
  final int sks;

  MatkulModel({
    required this.kode,
    required this.nama,
    required this.jadwal,
    required this.dosen,
    required this.sks,
  });

  factory MatkulModel.fromJson(Map<String, dynamic> json) {
    return MatkulModel(
      kode: json['kode'],
      nama: json['nama'],
      jadwal: json['jadwal'],
      dosen: json['dosen'],
      sks: json['sks'],
    );
  }
}

class PilihanKelasModel {
  final String kode;
  final String nama;
  final String jadwal;
  final int sks;

  PilihanKelasModel({
    required this.kode,
    required this.nama,
    required this.jadwal,
    required this.sks,
  });

  factory PilihanKelasModel.fromJson(Map<String, dynamic> json) {
    return PilihanKelasModel(
      kode: json['kode'],
      nama: json['nama'],
      jadwal: json['jadwal'],
      sks: json['sks'],
    );
  }
}