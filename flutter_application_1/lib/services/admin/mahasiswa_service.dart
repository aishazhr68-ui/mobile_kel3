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
  // 1. GET DAFTAR MAHASISWA
  // ==========================================
  Future<List<MahasiswaModel>> getMahasiswa() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(ApiConfig.mahasiswa), headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      
      List<dynamic> dataList = [];
      
      // 🔥 Logika pembongkaran data yang terbukti berhasil di kode Anda sebelumnya
      if (decoded['data'] != null) {
        if (decoded['data'] is List) {
          dataList = decoded['data'];
        } else if (decoded['data'] is Map && decoded['data']['data'] != null) {
          dataList = decoded['data']['data'];
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
  // 2. HAPUS MAHASISWA
  // ==========================================
  Future<void> deleteMahasiswa(String nim) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse(ApiConfig.deleteMahasiswa(nim)), headers: headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Gagal menghapus data: ${response.statusCode}");
    }
  }

  // ==========================================
  // 3. DETAIL MAHASISWA
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
}