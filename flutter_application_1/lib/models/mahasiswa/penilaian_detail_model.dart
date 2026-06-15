class KomponenNilaiModel {
  final String komponen;
  final int bobot;
  final int nilai;
  final double akhir;

  KomponenNilaiModel({
    required this.komponen,
    required this.bobot,
    required this.nilai,
    required this.akhir,
  });
}

class PenilaianDetailModel {
  final String namaMatkul;
  final String kodeMatkul;
  final String dosen;
  final String nidn;

  final List<KomponenNilaiModel> rincian;

  final double totalNilai;
  final String grade;

  PenilaianDetailModel({
    required this.namaMatkul,
    required this.kodeMatkul,
    required this.dosen,
    required this.nidn,
    required this.rincian,
    required this.totalNilai,
    required this.grade,
  });
}