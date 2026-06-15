class MatakuliahModel {
  final String kode;
  final String nama;
  final String kelas;
  final String dosen;

  MatakuliahModel({
    required this.kode,
    required this.nama,
    required this.kelas,
    required this.dosen,
  });

  factory MatakuliahModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MatakuliahModel(
      kode: json['kode'] ?? '',
      nama: json['nama'] ?? '',
      kelas: json['kelas'] ?? '',
      dosen: json['dosen'] ?? '',
    );
  }
}