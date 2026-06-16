class JadwalKelasModel {
  final String idKelas;
  final String namaKelas;
  final String programStudi;
  final int jumlahMahasiswa;

  JadwalKelasModel({
    required this.idKelas,
    required this.namaKelas,
    required this.programStudi,
    required this.jumlahMahasiswa,
  });

  factory JadwalKelasModel.fromJson(Map<String, dynamic> json) {
    return JadwalKelasModel(
      // Sesuaikan key di bawah ini dengan respon asli dari API Anda
      idKelas: json['id']?.toString() ?? "-", 
      namaKelas: json['nama_kelas']?.toString() ?? "Kelas Tidak Dikenal",
      programStudi: json['prodi']?['nama_prodi']?.toString() ?? "Prodi Tidak Diketahui",
      jumlahMahasiswa: int.tryParse(json['jumlah_mahasiswa']?.toString() ?? "0") ?? 0,
    );
  }
}