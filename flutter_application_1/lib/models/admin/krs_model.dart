class KrsModel {
  final String id;
  final String kelas;
  final int hadir;
  final int izin;

  KrsModel({
    required this.id,
    required this.kelas,
    required this.hadir,
    required this.izin,
  });

  factory KrsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return KrsModel(
      id: json['id'] ?? '',
      kelas: json['kelas'] ?? '',
      hadir: json['hadir'] ?? 0,
      izin: json['izin'] ?? 0,
    );
  }
}