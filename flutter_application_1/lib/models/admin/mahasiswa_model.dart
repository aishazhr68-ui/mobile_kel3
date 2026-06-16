class MahasiswaModel {
  // =========================================================================
  // PROPERTI MODEL MAHASISWA (Lengkap Sesuai Kebutuhan UI Detail & API)
  // =========================================================================
  
  // 1. Identitas Utama & Akademik
  final String nim;
  final String nama;
  final String email;
  final String noHp;
  final String tanggalLahir;
  final String jenisKelamin;
  final String agama;
  final String status;
  final String prodi;          // Menggantikan idProdi untuk menyimpan nama prodi tekstual
  final String tahunAkademik;
  final String kelas;

  // 2. Data Domisili
  final String alamat;
  final String provinsi;
  final String kabupatenKota;
  final String kecamatan;
  final String kelurahanDesa;
  final String kodePos;

  // 3. Data Orang Tua / Wali
  final String namaAyah;
  final String pekerjaanAyah;
  final String noHpAyah;
  final String penghasilanAyah;
  final String namaIbu;
  final String pekerjaanIbu;
  final String noHpIbu;
  final String penghasilanIbu;
  final String namaWali;
  final String pekerjaanWali;
  final String noHpWali;
  final String penghasilanWali;

  // 4. Data Sekolah & Ijazah
  final String jenisSekolah;
  final String namaSekolah;
  final String kotaSekolah;
  

  // =========================================================================
  // KONSTRUKTOR
  // =========================================================================
  MahasiswaModel({
    required this.nim,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.agama,
    required this.status,
    required this.prodi,
    required this.tahunAkademik,
    required this.kelas,
    required this.alamat,
    required this.provinsi,
    required this.kabupatenKota,
    required this.kecamatan,
    required this.kelurahanDesa,
    required this.kodePos,
    required this.namaAyah,
    required this.pekerjaanAyah,
    required this.noHpAyah,
    required this.penghasilanAyah,
    required this.namaIbu,
    required this.pekerjaanIbu,
    required this.noHpIbu,
    required this.penghasilanIbu,
    required this.namaWali,
    required this.pekerjaanWali,
    required this.noHpWali,
    required this.penghasilanWali,
    required this.jenisSekolah,
    required this.namaSekolah,
    required this.kotaSekolah,
  });

  // =========================================================================
  // FACTORY FROM JSON (Pencatatan & Ekstraksi Data dengan Fallback Aman)
  // =========================================================================
  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    // 1. Logika Ekstraksi Program Studi (Metode Aman Bawaan Anda)
    String prodiEkstrak = "D3 Teknik Pertambangan";
    if (json['prodi'] != null && json['prodi'] is Map) {
      prodiEkstrak = json['prodi']['nama_prodi']?.toString() ?? "D3 Teknik Pertambangan";
    } else if (json['nama_prodi'] != null) {
      prodiEkstrak = json['nama_prodi'].toString();
    } else if (json['jurusan'] != null) {
      prodiEkstrak = json['jurusan'].toString();
    } else if (json['id_prodi'] != null) {
      prodiEkstrak = json['id_prodi'].toString();
    }

    return MahasiswaModel(
      // Identitas Utama & Akademik
      nim: (json['nim'] ?? json['NIM'] ?? "-").toString(),
      nama: (json['nama'] ?? json['name'] ?? json['NAMA'] ?? "Tanpa Nama").toString(),
      email: (json['email'] ?? json['EMAIL'] ?? "-").toString(),
      noHp: (json['no_hp'] ?? json['nohp'] ?? json['NO_HP'] ?? "-").toString(),
      tanggalLahir: (json['tanggal_lahir'] ?? json['TANGGAL_LAHIR'] ?? "-").toString(),
      jenisKelamin: (json['jenis_kelamin'] ?? json['jk'] ?? json['JENIS_KELAMIN'] ?? "-").toString(),
      agama: (json['agama'] ?? json['AGAMA'] ?? "-").toString(),
      status: (json['status']?.toString().toUpperCase() == "AKTIF" || 
         json['id_status_mhs']?.toString() == "1" || 
         json['ID_STATUS_MHS']?.toString() == "1") 
         ? "AKTIF" 
         : "TIDAK AKTIF",
      prodi: prodiEkstrak,
      tahunAkademik: (json['tahun_akademik'] ?? json['TAHUN_AKADEMIK'] ?? "2025/2026").toString(),
      kelas: (json['kelas'] ?? json['KELAS'] ?? json['id_kelas'] ?? "-").toString(),

      // Data Domisili
      alamat: (json['alamat'] ?? json['ALAMAT'] ?? "-").toString(),
      provinsi: (json['provinsi'] ?? json['PROVINSI'] ?? "-").toString(),
      kabupatenKota: (json['kabupaten_kota'] ?? json['KABUPATEN_KOTA'] ?? json['kota'] ?? "-").toString(),
      kecamatan: (json['kecamatan'] ?? json['KECAMATAN'] ?? "-").toString(),
      kelurahanDesa: (json['kelurahan_desa'] ?? json['KELURAHAN_DESA'] ?? json['kelurahan'] ?? "-").toString(),
      kodePos: (json['kode_pos'] ?? json['KODE_POS'] ?? "-").toString(),
      

      // Data Orang Tua / Wali
      namaAyah: (json['nama_ayah'] ?? json['NAMA_AYAH'] ?? "-").toString(),
      pekerjaanAyah: (json['pekerjaan_ayah'] ?? json['PEKERJAAN_AYAH'] ?? "-").toString(),
      noHpAyah: (json['no_hp_ayah'] ?? json['NO_HP_AYAH'] ?? "-").toString(),
      penghasilanAyah: (json['penghasilan_ayah'] ?? json['PENGHASILAN_AYAH'] ?? "-").toString(),
      
      namaIbu: (json['nama_ibu'] ?? json['NAMA_IBU'] ?? "-").toString(),
      pekerjaanIbu: (json['pekerjaan_ibu'] ?? json['PEKERJAAN_IBU'] ?? "-").toString(),
      noHpIbu: (json['no_hp_ibu'] ?? json['NO_HP_IBU'] ?? "-").toString(),
      penghasilanIbu: (json['penghasilan_ibu'] ?? json['PENGHASILAN_IBU'] ?? "-").toString(),
      
      namaWali: (json['nama_wali'] ?? json['NAMA_WALI'] ?? "-").toString(),
      pekerjaanWali: (json['pekerjaan_wali'] ?? json['PEKERJAAN_WALI'] ?? "-").toString(),
      noHpWali: (json['no_hp_wali'] ?? json['NO_HP_WALI'] ?? "-").toString(),
      penghasilanWali: (json['penghasilan_wali'] ?? json['PENGHASILAN_WALI'] ?? "-").toString(),

      // Data Sekolah & Ijazah
      jenisSekolah: (json['jenis_sekolah'] ?? json['JENIS_SEKOLAH'] ?? "-").toString(),
      namaSekolah: (json['nama_sekolah'] ?? json['NAMA_SEKOLAH'] ?? json['asal_sekolah'] ?? "-").toString(),
      kotaSekolah: (json['kota_sekolah'] ?? json['KOTA_SEKOLAH'] ?? "-").toString(),
    );
  }
}