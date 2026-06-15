class ApiConfig {

    static const String baseUrl = "https://api-admin-4c.rifkiaja.my.id:9002/api";
    static const String baseUrlKeuangan = "https://keuangan4c06.vps-poliban.my.id/api";


  // =======================================
  // 1. AUTHENTICATION
  // =======================================
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String refresh = '$baseUrl/auth/refresh';

  // =======================================
  // 2. PROFILE
  // =======================================
  static const String getProfile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile';
  static const String changePassword = '$baseUrl/profile/change-password';

  // =======================================
  // 3. MAHASISWA & USER MANAGEMENT (Admin)
  // =======================================
  static const String mahasiswa = '$baseUrl/mahasiswa'; 
  static String detailMahasiswa(String nim) => '$baseUrl/mahasiswa/$nim';
  static String updateMahasiswa(String nim) => '$baseUrl/mahasiswa/$nim';
  static String deleteMahasiswa(String nim) => '$baseUrl/mahasiswa/$nim';
  static String searchMahasiswaByNama(String nama) => '$baseUrl/mahasiswa/search/$nama';
  static String filterMahasiswaByStatusId(String idStatus) => '$baseUrl/mahasiswa/status/$idStatus';
  
  
  // Admin Mahasiswa: Mengaktifkan kembali atau memblokir akun mahasiswa (Suspend Account)
  static String updateStatusAktifMhs(String nim) => '$baseUrl/mahasiswa/$nim/update-status';
  // Admin Mahasiswa: Mengunduh template / Import massal data mahasiswa via Excel/CSV
  static const String importMahasiswaExcel = '$baseUrl/mahasiswa/import-excel';

  // =======================================
  // 4. AKADEMIK
  // =======================================

  // -------- Base path KHS --------
  static const String khs = '$baseUrl/akademik/khs';
  
  // Layar ke-1: Ambil Rekap Kelas untuk Modul KHS
  static const String getRekapKhsKelas = '$khs/rekap-kelas';
  // Layar ke-2: Ambil Daftar Mahasiswa, IPK, dan Status Kelulusan di Kelas Tertentu
  static String getKhsMhsPerKelas(String idKelas) => '$khs?id_kelas=$idKelas';
  // Layar ke-3: Ambil Detail KHS 1 Mahasiswa Berdasarkan ID KHS (Memuat IPS, IPK, & List Nilai)
  static String detailKhs(int idKhs) => '$khs/$idKhs';
  // Alternatif Layar ke-3: (Jika backend menggunakan parameter filter NIM dan Periode/Semester)
  static String detailKhsByNim(String nim, String periode) => '$khs/detail?nim=$nim&periode=$periode';

  // -------- Base path KRS --------
  static const String krs = '$baseUrl/akademik/krs';
  
  // Layar ke-1: Ambil Rekap Status KRS per Kelas (Jumlah Disetujui vs Belum)
  static const String getRekapKrsKelas = '$krs/rekap-kelas';
  // Layar ke-2: Ambil Daftar Mahasiswa & Status KRS di Kelas Tertentu
  static String getKrsMhsPerKelas(String idKelas) => '$krs?id_kelas=$idKelas';
  // Layar ke-3: Ambil Detail KRS 1 Mahasiswa berdasarkan ID KRS atau NIM & Periode
  static String detailKrs(int idKrs) => '$krs/$idKrs';
  // Alternatif Layar ke-3 (Jika backend menggunakan parameter NIM dan Periode/Semester)
  static String detailKrsByNim(String nim, String periode) => '$krs/detail?nim=$nim&periode=$periode';
  
  
  // Mahasiswa: Menyimpan daftar matakuliah pilihan ke dalam database saat pengisian KRS
  static const String simpanKrsMahasiswa = '$krs/store';
  // Admin Mahasiswa / Dosen Wali: Menyetujui (Approve) atau Menolak KRS Mahasiswa
  static String verifikasiKrsAdmin(int idKrs) => '$krs/verifikasi/$idKrs';

  // -------- Base path untuk modul nilai --------
  static const String nilai = '$baseUrl/akademik/nilai';
  
  // Layar ke-3: Ambil Rekap Nilai Utama 1 Kelas (Berdasarkan ID Kelas Matakuliah)
  static String getNilaiKelas(int idKelasMk) => '$nilai?id_kelas_mk=$idKelasMk';
  // Layar ke-4: Ambil Detail Total Nilai Akhir & KHS 1 Mahasiswa
  static String detailNilai(int idNilai) => '$nilai/$idNilai';
  // Layar ke-4 (Komponen): Ambil Pengaturan Bobot Persentase dari Dosen (Tugas, UTS, UAS, dll)
  static String getBobotNilai(String idKelas, String idMk) => '$baseUrl/nilai/settings?id_kelas=$idKelas&id_mk=$idMk';

  // -------- Base path PRESENSI --------
  static const String presensi = '$baseUrl/akademik/presensi-mahasiswa';
  
  // Endpoint Get Detail Presensi By ID
  static String detailPresensi(int idPresensi) => '$presensi/$idPresensi';
  // Endpoint Get Roster
  static String getRosterPresensi(int idKelasMk, int pertemuanKe) => '$presensi/roster?id_kelas_mk=$idKelasMk&pertemuan_ke=$pertemuanKe';
  // Endpoint Submit Batch (Massal)
  static const String submitBatchPresensi = '$presensi/batch-roll-call';
  
  // -------- Kelas MK & Jadwal --------
  static const String kelasMk = '$baseUrl/akademik/kelas-mk';
  // Layar ke-1: Mengambil daftar kelas-kelas kuliah (Bisa diambil dari base kelas atau relasi ini)
  static const String getKelasJadwal = '$baseUrl/akademik/kelas'; 
  // Layar ke-2: Mengambil Rincian Jadwal Kuliah Berdasarkan ID Kelas tertentu
  static String getJadwalPerKelas(String idKelas) => '$kelasMk?id_kelas=$idKelas';
  // Base path untuk modul jadwal umum
  static const String jadwal = '$baseUrl/akademik/jadwal';
  // Digunakan di KHS/KRS untuk mencari tahu relasi kelas fisik mahasiswa (misal: TI-4C)
  static String detailKelasMaster(int idKelasMaster) => '$baseUrl/Akademik/akademik/kelas-master/$idKelasMaster';

  // =======================================
  // 5. DATA MASTER
  // =======================================
  static const String prodi = '$baseUrl/data-master/prodi';
  static const String matakuliah = '$baseUrl/data-master/mata-kuliah';
  static const String tahunAkademik = '$baseUrl/data-master/tahun-akademik';
  static const String hari = '$baseUrl/data-master/hari';
  static const String ruang = '$baseUrl/data-master/ruang';
  static const String jurusan = '$baseUrl/data-master/jurusan';
  static const String jenisKelamin = '$baseUrl/jenis-kelamin';
  static const String statusMhs = '$baseUrl/status-mhs';

  // =======================================
  // 6. ROLE MAHASISWA (Akses Khusus Mahasiswa)
  // =======================================
  
  // -------- Presensi Mahasiswa --------
  // Dosen: Submit data presensi mahasiswa secara manual (Bulk Insert/Update)
  static const String submitPresensiManual = '$baseUrl/absensi/manual';
  // Mengambil data rekap absensi berdasarkan Kelas, Mata Kuliah, dan Pertemuan
  static String getRekapAbsensi(String idKelas, String idMk, String kodePertemuan) => 
      '$baseUrl/absensi/rekap?id_kelas=$idKelas&id_mk=$idMk&kode_pertemuan=$kodePertemuan';
      
  
  // Mahasiswa: Cek status apakah sesi absen sudah dibuka oleh dosen atau belum
  static String cekStatusSesiMhs(String idKelasMk, String pertemuanKe) => 
      '$baseUrl/akademik/presensi-mahasiswa/status?id_kelas_mk=$idKelasMk&pertemuan_ke=$pertemuanKe';
  // Mahasiswa: Mengirim status kehadiran mandiri ke server (Hadir/Izin/Sakit)
  static const String submitPresensiMandiriMhs = '$baseUrl/akademik/presensi-mahasiswa/submit';

  // -------- Jadwal Mahasiswa --------
  // Mengambil jadwal perkuliahan khusus untuk mahasiswa yang sedang login
  static const String getJadwalMahasiswa = '$baseUrl/mahasiswa/jadwal';

  // -------- Penilaian Mahasiswa --------
  // Layar 1: Ambil daftar matakuliah & nilai akhir untuk mahasiswa yang sedang login
  static const String getNilaiMahasiswa = '$baseUrl/mahasiswa/nilai';
  // Layar 2: Ambil rincian komponen (Bobot & Nilai Mentah Tugas, UTS, UAS) per matakuliah
  static String getDetailNilaiMahasiswa(String idMk) => 
      '$baseUrl/mahasiswa/nilai/detail?id_mk=$idMk';

  // =======================================
  // 6. KEUANGAN
  // =======================================
static const String uktKategori = '$baseUrl/Keuangan/ukt-kategori';
  
  //  Detail kategori UKT berdasarkan ID (Dari cURL /ukt-kategori/1 Anda)
  static String detailUktKategori(int id) => '$baseUrlKeuangan/ukt-kategori/$id';

  //  Master Data Status Keuangan Mahasiswa
  static const String statusMahasiswaKeuangan = '$baseUrl/Keuangan/status-mahasiswa';

  // Menampilkan tagihan aktif di Tab "Belum Dibayar" (Dari cURL /api/tagihan Anda)
  static const String getTagihanMahasiswa = '$baseUrlKeuangan/tagihan';

  // Detail Informasi 1 Tagihan Berdasarkan ID (Dari cURL /tagihan/1 Anda)
  // Digunakan untuk menampilkan pop-up konfirmasi pembayaran
  static String detailTagihanMahasiswa(int idTagihan) => '$baseUrlKeuangan/tagihan/$idTagihan';

//Master Data List Status Tagihan (Dari cURL /status-tagihan Anda)
  static const String statusTagihan = '$baseUrlKeuangan/status-tagihan';


}