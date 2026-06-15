class MahasiswaModel {
  final String nim;
  final String nama;
  final String jurusan;
  final String semester;
  final String status;

  MahasiswaModel({
    required this.nim,
    required this.nama,
    required this.jurusan,
    required this.semester,
    required this.status,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      jurusan: json['jurusan'] ?? '',
      semester: json['semester'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'nama': nama,
      'jurusan': jurusan,
      'semester': semester,
      'status': status,
    };
  }
}