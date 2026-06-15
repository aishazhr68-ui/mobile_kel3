class DashboardModel {
  final int totalMahasiswa;
  final int totalMahasiswaAktif;
  final int totalPengajuanKrs;

  DashboardModel({
    required this.totalMahasiswa,
    required this.totalMahasiswaAktif,
    required this.totalPengajuanKrs,
  });

  factory DashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardModel(
      totalMahasiswa:
          json['total_mahasiswa'] ?? 0,

      totalMahasiswaAktif:
          json['total_mahasiswa_aktif'] ?? 0,

      totalPengajuanKrs:
          json['total_pengajuan_krs'] ?? 0,
    );
  }
}