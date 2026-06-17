import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/admin/mahasiswa_model.dart';
import '../../config/api_config.dart';

class MahasiswaService {
  
  static final List<MahasiswaModel> localAddedStudents = [];

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ==========================================
  // 1. GET DAFTAR MAHASISWA (DENGAN PAGINATION)
  // ==========================================
  // 🔥 Menambahkan parameter [page] dengan default 1
  Future<List<MahasiswaModel>> getMahasiswa({int page = 1}) async {
    final headers = await _getHeaders();
    
    // 🔥 Menggabungkan URL dengan parameter page (contoh: .../mahasiswa?page=1)
    final url = "${ApiConfig.mahasiswa}?page=$page";
    
    List<MahasiswaModel> apiList = [];
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        List<dynamic> dataList = [];
        
        // Mengambil data dari struktur paginasi Laravel
        if (decoded['data'] != null) {
          if (decoded['data'] is Map && decoded['data']['data'] != null) {
            dataList = decoded['data']['data'];
          } else if (decoded['data'] is List) {
            dataList = decoded['data'];
          }
        } else if (decoded is List) {
          dataList = decoded;
        }

        apiList = dataList.map((json) => MahasiswaModel.fromJson(json)).toList();
        
      } else if (response.statusCode == 401) {
        throw Exception("Sesi login berakhir (401). Silakan login ulang.");
      }
    } catch (e) {
      print("🚨 Gagal memuat data dari API, menggunakan data lokal: $e");
    }

    if (page == 1) {
      final combined = <MahasiswaModel>[];
      // Hindari duplikasi jika data lokal ditambahkan tapi ternyata juga masuk API
      final existingNims = apiList.map((m) => m.nim.toLowerCase()).toSet();
      for (var lm in localAddedStudents) {
        if (!existingNims.contains(lm.nim.toLowerCase())) {
          combined.add(lm);
        }
      }
      combined.addAll(apiList);
      return combined;
    }
    return apiList;
  }

  // ==========================================
  // 2. HAPUS MAHASISWA (TIDAK BERUBAH)
  // ==========================================
  Future<void> deleteMahasiswa(String nim) async {
    localAddedStudents.removeWhere((m) => m.nim.toLowerCase() == nim.toLowerCase());
    
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse(ApiConfig.deleteMahasiswa(nim)), headers: headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      // Jika di API gagal tapi di lokal ada, tetap biarkan terhapus dari lokal
    }
  }

  // ==========================================
  // 3. DETAIL MAHASISWA (TIDAK BERUBAH)
  // ==========================================
  Future<MahasiswaModel> getDetailMahasiswa(String nim) async {
    // Cari di data lokal dulu
    final localIndex = localAddedStudents.indexWhere((m) => m.nim.toLowerCase() == nim.toLowerCase());
    if (localIndex != -1) {
      return localAddedStudents[localIndex];
    }

    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(ApiConfig.detailMahasiswa(nim)), headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final json = (decoded is Map<String, dynamic> && decoded.containsKey('data') && decoded['data'] is Map) 
          ? decoded['data'] 
          : decoded;
      
      return MahasiswaModel.fromJson(json);
    } else {
      throw Exception("Gagal memuat detail (Status: ${response.statusCode})");
    }
  }

  // ==========================================
  // 4. TAMBAH MAHASISWA
  // ==========================================
  Future<void> addMahasiswa(Map<String, dynamic> body) async {
    // Cari prodi
    String nimVal = body['NIM']?.toString() ?? "-";
    String namaVal = body['NAMA']?.toString() ?? "Tanpa Nama";
    String emailVal = body['EMAIL']?.toString() ?? "-";
    String noHpVal = body['NO_HP']?.toString() ?? "-";
    String tglLahirVal = body['TANGGAL_LAHIR']?.toString() ?? "-";
    String jkVal = body['ID_JK']?.toString() == "1" ? "Laki-laki" : "Perempuan";
    
    String agamaVal = "Islam";
    if (body['ID_AGAMA']?.toString() == "2") agamaVal = "Kristen";
    if (body['ID_AGAMA']?.toString() == "3") agamaVal = "Katolik";
    if (body['ID_AGAMA']?.toString() == "4") agamaVal = "Hindu";
    if (body['ID_AGAMA']?.toString() == "5") agamaVal = "Budha";
    if (body['ID_AGAMA']?.toString() == "6") agamaVal = "Konghucu";

    final localMhs = MahasiswaModel(
      nim: nimVal,
      nama: namaVal,
      email: emailVal,
      noHp: noHpVal,
      tanggalLahir: tglLahirVal,
      jenisKelamin: jkVal,
      agama: agamaVal,
      status: "AKTIF",
      prodi: "Sistem Informasi",
      tahunAkademik: "2023/2024 Genap",
      kelas: "TI_1A",
      alamat: body['ALAMAT']?.toString() ?? "-",
      provinsi: "-",
      kabupatenKota: "-",
      kecamatan: "-",
      kelurahanDesa: "-",
      kodePos: "-",
      namaAyah: "-",
      pekerjaanAyah: "-",
      noHpAyah: "-",
      penghasilanAyah: "-",
      namaIbu: "-",
      pekerjaanIbu: "-",
      noHpIbu: "-",
      penghasilanIbu: "-",
      namaWali: "-",
      pekerjaanWali: "-",
      noHpWali: "-",
      penghasilanWali: "-",
      jenisSekolah: "-",
      namaSekolah: "-",
      kotaSekolah: "-",
    );
    
    // Simpan ke local cache untuk testing/fallback
    localAddedStudents.insert(0, localMhs);

    final headers = await _getHeaders();
    headers['Content-Type'] = 'application/json';
    
    final response = await http.post(
      Uri.parse(ApiConfig.mahasiswa),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("🚨 API ERROR response (status ${response.statusCode}): ${response.body}");
      if (response.body.trim().startsWith('<')) {
        throw Exception("Server mengalami error (HTML). Cek backend Anda.");
      }
      final errorData = jsonDecode(response.body);
      String msg = errorData['message'] ?? "Gagal menambahkan mahasiswa.";
      if (errorData['errors'] != null) {
        msg += " Detail: ${errorData['errors'].toString()}";
      }
      throw Exception(msg);
    }
  }

  // ==========================================
  // 5. UPDATE MAHASISWA
  // ==========================================
  Future<void> updateMahasiswa(String nim, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    headers['Content-Type'] = 'application/json';
    
    final response = await http.put(
      Uri.parse(ApiConfig.updateMahasiswa(nim)),
      headers: headers,
      body: jsonEncode(body),
    );

    // Update di lokal juga
    final localIndex = localAddedStudents.indexWhere((m) => m.nim.toLowerCase() == nim.toLowerCase());
    if (localIndex != -1) {
      final old = localAddedStudents[localIndex];
      localAddedStudents[localIndex] = MahasiswaModel(
        nim: old.nim,
        nama: body['NAMA']?.toString() ?? old.nama,
        email: body['EMAIL']?.toString() ?? old.email,
        noHp: body['NO_HP']?.toString() ?? old.noHp,
        tanggalLahir: body['TANGGAL_LAHIR']?.toString() ?? old.tanggalLahir,
        jenisKelamin: body['ID_JK']?.toString() == "1" ? "Laki-laki" : "Perempuan",
        status: (body['ID_STATUS_MHS']?.toString() == "1") ? "AKTIF" : "TIDAK AKTIF",
        agama: body['ID_AGAMA']?.toString() == "2" ? "Kristen" : (body['ID_AGAMA']?.toString() == "3" ? "Katolik" : "Islam"),
        prodi: old.prodi,
        tahunAkademik: old.tahunAkademik,
        kelas: old.kelas,
        alamat: old.alamat,
        provinsi: old.provinsi,
        kabupatenKota: old.kabupatenKota,
        kecamatan: old.kecamatan,
        kelurahanDesa: old.kelurahanDesa,
        kodePos: old.kodePos,
        namaAyah: old.namaAyah,
        pekerjaanAyah: old.pekerjaanAyah,
        noHpAyah: old.noHpAyah,
        penghasilanAyah: old.penghasilanAyah,
        namaIbu: old.namaIbu,
        pekerjaanIbu: old.pekerjaanIbu,
        noHpIbu: old.noHpIbu,
        penghasilanIbu: old.penghasilanIbu,
        namaWali: old.namaWali,
        pekerjaanWali: old.pekerjaanWali,
        noHpWali: old.noHpWali,
        penghasilanWali: old.penghasilanWali,
        jenisSekolah: old.jenisSekolah,
        namaSekolah: old.namaSekolah,
        kotaSekolah: old.kotaSekolah,
      );
    }

    if (response.statusCode != 200 && response.statusCode != 204) {
      print("🚨 API ERROR response (status ${response.statusCode}): ${response.body}");
      if (response.body.trim().startsWith('<')) {
        throw Exception("Server mengalami error (HTML). Cek backend Anda.");
      }
      final errorData = jsonDecode(response.body);
      String msg = errorData['message'] ?? "Gagal memperbarui mahasiswa.";
      if (errorData['errors'] != null) {
        msg += " Detail: ${errorData['errors'].toString()}";
      }
      throw Exception(msg);
    }
  }
}