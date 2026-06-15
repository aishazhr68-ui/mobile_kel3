// Lokasi: lib/models/jadwal_detail_model.dart

class JadwalMataKuliah {
  final String namaMataKuliah;
  final int sks;
  final String waktu;
  final String ruang;
  final String namaDosen;

  JadwalMataKuliah({
    required this.namaMataKuliah,
    required this.sks,
    required this.waktu,
    required this.ruang,
    required this.namaDosen,
  });
}