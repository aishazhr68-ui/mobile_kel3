class KelasPresensiModel {
  final String id;
  final String kelas;

  KelasPresensiModel({
    required this.id,
    required this.kelas,
  });

  factory KelasPresensiModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return KelasPresensiModel(
      id: json['id'] ?? '',
      kelas: json['kelas'] ?? '',
    );
  }
}