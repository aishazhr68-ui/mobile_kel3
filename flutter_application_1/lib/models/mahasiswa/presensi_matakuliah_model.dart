// Lokasi: lib/models/mahasiswa/presensi_matakuliah_model.dart

class PresensiMatakuliahMahasiswaModel {
  final String namaMatkul;
  final int sesiHadir;
  final int totalSesi;
  final int persentase;

  PresensiMatakuliahMahasiswaModel({
    required this.namaMatkul,
    required this.sesiHadir,
    required this.totalSesi,
    required this.persentase,
  });

  factory PresensiMatakuliahMahasiswaModel.fromJson(Map<String, dynamic> json) {
    return PresensiMatakuliahMahasiswaModel(
      namaMatkul: json['nama_matkul'] ?? '',
      sesiHadir: json['sesi_hadir'] ?? 0,
      totalSesi: json['total_sesi'] ?? 0,
      persentase: json['persentase'] ?? 0,
    );
  }
}