import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/models/admin/jadwal_kuliah_model.dart';

class JadwalKuliahService {
  Future<List<JadwalKelasModel>> getJadwalKelas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(ApiConfig.getKelasJadwal),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // Asumsi data berada di key 'data'
      List<dynamic> data = decoded['data'] ?? [];
      
      return data.map((json) => JadwalKelasModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal memuat jadwal: ${response.statusCode}");
    }
  }
}