class NilaiModel {
  final String nim;
  final String nama;
  final double nilai;
  final String grade;

  NilaiModel({
    required this.nim,
    required this.nama,
    required this.nilai,
    required this.grade,
  });

  factory NilaiModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NilaiModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      nilai: (json['nilai'] ?? 0).toDouble(),
      grade: json['grade'] ?? '',
    );
  }
}