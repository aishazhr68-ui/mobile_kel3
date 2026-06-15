import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/config/api_config.dart';

class DashboardService {
  Future<dynamic> getDashboardData() async {
    // 1. Ambil token yang tersimpan saat login
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Pastikan token tidak null
    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login kembali.");
    }

    // 2. Lakukan request HTTP GET
    final response = await http.get(
      // 🔥 PERBAIKAN 1: Ganti endpoint ke URL Dashboard yang sebenarnya, BUKAN auth/login
      // Contoh: Uri.parse('${ApiConfig.baseUrl}/dashboard'), atau jika ada variabelnya:
      Uri.parse('${ApiConfig.baseUrl}/dashboard_admin'), 
      
      // 🔥 PERBAIKAN 2: Gunakan koma (,), bukan titik koma (;) di sini
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Sesi telah habis (401 Unauthorized). Silakan login ulang.");
    } else {
      throw Exception("Gagal memuat data: ${response.statusCode}");
    }
  }
}