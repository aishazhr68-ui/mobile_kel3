class MahasiswaModel {
  final String nim, nama, email, noHp, tanggalLahir, alamat, namaAyah, namaIbu, 
              pekerjaanAyah, penghasilanAyah, kotaSekolah, status, idProdi;

  MahasiswaModel({
    required this.nim, required this.nama, required this.email, required this.noHp,
    required this.tanggalLahir, required this.alamat, required this.namaAyah,
    required this.namaIbu, required this.pekerjaanAyah, required this.penghasilanAyah,
    required this.kotaSekolah, required this.status, required this.idProdi,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    // 🔥 Logika ekstrak jurusan yang paling aman (Sesuai kode asli Anda)
    String prodi = "Teknik Pertambangan";
    if (json['prodi'] != null && json['prodi'] is Map) {
      prodi = json['prodi']['nama_prodi']?.toString() ?? "Teknik Pertambangan";
    } else if (json['nama_prodi'] != null) {
      prodi = json['nama_prodi'].toString();
    } else if (json['jurusan'] != null) {
      prodi = json['jurusan'].toString();
    } else if (json['id_prodi'] != null) {
      prodi = json['id_prodi'].toString();
    }

    return MahasiswaModel(
      nim: (json['nim'] ?? json['NIM'] ?? "-").toString(),
      nama: (json['nama'] ?? json['name'] ?? json['NAMA'] ?? "Tanpa Nama").toString(),
      email: (json['email'] ?? json['EMAIL'] ?? "-").toString(),
      noHp: (json['no_hp'] ?? json['nohp'] ?? json['NO_HP'] ?? "-").toString(),
      tanggalLahir: (json['tanggal_lahir'] ?? json['TANGGAL_LAHIR'] ?? "-").toString(),
      alamat: (json['alamat'] ?? json['ALAMAT'] ?? "-").toString(),
      namaAyah: (json['nama_ayah'] ?? json['NAMA_AYAH'] ?? "-").toString(),
      namaIbu: (json['nama_ibu'] ?? json['NAMA_IBU'] ?? "-").toString(),
      pekerjaanAyah: (json['pekerjaan_ayah'] ?? json['ID_PEKERJAAN_AYAH'] ?? "-").toString(),
      penghasilanAyah: (json['penghasilan_ayah'] ?? json['PENGHASILAN_AYAH'] ?? "-").toString(),
      kotaSekolah: (json['kota_sekolah'] ?? json['KOTA_SEKOLAH'] ?? "-").toString(),
      
      // Status
      status: (json['status']?.toString().toUpperCase() == "AKTIF" || 
               json['id_status_mhs']?.toString() == "1") ? "AKTIF" : "TIDAK AKTIF",
               
      idProdi: prodi,
    );
  }
}