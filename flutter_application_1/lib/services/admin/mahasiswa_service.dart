import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/admin/mahasiswa_model.dart';
import '../../config/api_config.dart';

class MahasiswaService {
  
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

      return dataList.map((json) => MahasiswaModel.fromJson(json)).toList();
      
    } else if (response.statusCode == 401) {
      throw Exception("Sesi login berakhir (401). Silakan login ulang.");
    } else {
      throw Exception("Gagal memuat data (Status: ${response.statusCode})");
    }
  }

  // ==========================================
  // 2. HAPUS MAHASISWA (TIDAK BERUBAH)
  // ==========================================
  Future<void> deleteMahasiswa(String nim) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse(ApiConfig.deleteMahasiswa(nim)), headers: headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Gagal menghapus data: ${response.statusCode}");
    }
  }

  // ==========================================
  // 3. DETAIL MAHASISWA (TIDAK BERUBAH)
  // ==========================================
  Future<MahasiswaModel> getDetailMahasiswa(String nim) async {
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
    final headers = await _getHeaders();
    headers['Content-Type'] = 'application/json';
    
    final response = await http.post(
      Uri.parse(ApiConfig.mahasiswa),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      if (response.body.trim().startsWith('<')) {
        throw Exception("Server mengalami error (HTML). Cek backend Anda.");
      }
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? "Gagal menambahkan mahasiswa.");
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

    if (response.statusCode != 200 && response.statusCode != 204) {
      if (response.body.trim().startsWith('<')) {
        throw Exception("Server mengalami error (HTML). Cek backend Anda.");
      }
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? "Gagal memperbarui mahasiswa.");
    }
  }
}