class PenilaianMatakuliahModel {
  final String id;
  final String namaMatkul;
  final String dosen;

  PenilaianMatakuliahModel({
    required this.id,
    required this.namaMatkul,
    required this.dosen,
  });

  factory PenilaianMatakuliahModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PenilaianMatakuliahModel(
      id: json['id'] ?? '',
      namaMatkul: json['namaMatkul'] ?? '',
      dosen: json['dosen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaMatkul': namaMatkul,
      'dosen': dosen,
    };
  }
}