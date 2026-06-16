// Lokasi: lib/models/admin/dashboard_admin_model.dart

class DashboardModel {
  final int totalMahasiswa;
  final int mahasiswaAktif;
  final int totalTagihanUkt;
  final List<JadwalDashboard> jadwalPerkuliahan;

  DashboardModel({
    required this.totalMahasiswa,
    required this.mahasiswaAktif,
    required this.totalTagihanUkt,
    required this.jadwalPerkuliahan,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    // Menangani array jadwal perkuliahan
    List<JadwalDashboard> listJadwal = [];
    if (json['jadwal_perkuliahan'] != null && json['jadwal_perkuliahan'] is List) {
      for (var item in json['jadwal_perkuliahan']) {
        if (item != null) { // Memastikan item tidak null
          listJadwal.add(JadwalDashboard.fromJson(item));
        }
      }
    }

    return DashboardModel(
      totalMahasiswa: int.tryParse(json['total_mahasiswa']?.toString() ?? '0') ?? 0,
      mahasiswaAktif: int.tryParse(json['mahasiswa_aktif']?.toString() ?? '0') ?? 0,
      totalTagihanUkt: int.tryParse(json['total_tagihan_ukt']?.toString() ?? '0') ?? 0,
      jadwalPerkuliahan: listJadwal,
    );
  }
}

// Kelas khusus untuk menampung data Jadwal di dalam Dashboard
class JadwalDashboard {
  final String namaMk;
  final String namaKelas;
  final String ruang;
  final String jamMulai;
  final String jamSelesai;
  final String hariTanggal;

  JadwalDashboard({
    required this.namaMk,
    required this.namaKelas,
    required this.ruang,
    required this.jamMulai,
    required this.jamSelesai,
    required this.hariTanggal,
  });

 factory JadwalDashboard.fromJson(Map<String, dynamic> json) {
  return JadwalDashboard(
    // Kita cek apakah data ada di level atas atau di dalam objek lain
    namaMk: json['nama_mk']?.toString() ?? json['mata_kuliah']?['nama_mk']?.toString() ?? "Matakuliah Tidak Diketahui",
    namaKelas: json['nama_kelas']?.toString() ?? json['kelas']?['nama_kelas']?.toString() ?? "-",
    ruang: json['ruang']?.toString() ?? json['nama_ruang']?.toString() ?? "-",
    jamMulai: json['jam_mulai']?.toString() ?? "00:00",
    jamSelesai: json['jam_selesai']?.toString() ?? "00:00",
    hariTanggal: json['hari']?.toString() ?? "Hari ini",
  );
}
}