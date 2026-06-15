class KhsModel {
  final String id;
  final String kelas;
  final int hadir;
  final int izin;

  KhsModel({
    required this.id,
    required this.kelas,
    required this.hadir,
    required this.izin,
  });

  factory KhsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return KhsModel(
      id: json['id'] ?? '',
      kelas: json['kelas'] ?? '',
      hadir: json['hadir'] ?? 0,
      izin: json['izin'] ?? 0,
    );
  }
}