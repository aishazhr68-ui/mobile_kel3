class PresensiModel {
  final String nim;
  final String nama;
  final int hadir;
  final int total;

  PresensiModel({
    required this.nim,
    required this.nama,
    required this.hadir,
    required this.total,
  });

  factory PresensiModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PresensiModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      hadir: json['hadir'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}