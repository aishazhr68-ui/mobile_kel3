// Lokasi: lib/models/presensi_model.dart

class PresensiMahasiswaModel {
  final String statusSesi;
  final String namaMatkul;
  final String lokasi;
  final String kelas;
  final String waktu;
  final String deskripsiSesi;
  final String namaDosen;
  final String statusPresensi;

  PresensiMahasiswaModel({
    required this.statusSesi,
    required this.namaMatkul,
    required this.lokasi,
    required this.kelas,
    required this.waktu,
    required this.deskripsiSesi,
    required this.namaDosen,
    required this.statusPresensi,
  });
}