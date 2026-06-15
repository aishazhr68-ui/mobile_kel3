class StudentInfoModel {
  final String nama;
  final String nim;
  final String prodi;
  final double ipk;
  final int totalSks;
  final String semesterAktif;

  StudentInfoModel({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.ipk,
    required this.totalSks,
    required this.semesterAktif,
  });
}

class JadwalHariIniModel {
  final String namaMatkul;
  final String waktu;
  final String ruang;
  final String namaDosen;

  JadwalHariIniModel({
    required this.namaMatkul,
    required this.waktu,
    required this.ruang,
    required this.namaDosen,
  });
}

class DashboardMahasiswaModel {
  final StudentInfoModel studentInfo;
  final List<JadwalHariIniModel> jadwalHariIni;

  DashboardMahasiswaModel({
    required this.studentInfo,
    required this.jadwalHariIni,
  });
}