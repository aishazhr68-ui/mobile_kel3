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
      idKelas: json['id_kelas']?.toString() ?? json['id']?.toString() ?? "-", 
      namaKelas: json['kelas_nama']?.toString() ?? json['nama_kelas']?.toString() ?? "Kelas Tidak Dikenal",
      programStudi: json['prodi']?['nama_prodi']?.toString() ?? "Prodi Tidak Diketahui",
      jumlahMahasiswa: int.tryParse(
        json['jumlah_mahasiswa']?.toString() ?? 
        json['mahasiswas_count']?.toString() ?? 
        json['mahasiswa_count']?.toString() ?? 
        (json['mahasiswas'] is List ? (json['mahasiswas'] as List).length.toString() : null) ??
        "0"
      ) ?? 0,
    );
  }
}