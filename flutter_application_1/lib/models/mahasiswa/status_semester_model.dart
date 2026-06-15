class StatusSemesterModel {
  final String semester;
  final String tahunAkademik;
  final String status;
  final String ips;
  final String ipk;
  final String sks; // Tambahkan properti ini

  StatusSemesterModel({
    required this.semester,
    required this.tahunAkademik,
    required this.status,
    required this.ips,
    required this.ipk,
    required this.sks,
  });
}