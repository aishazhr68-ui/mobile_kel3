import 'dart:convert';
import 'package:flutter/material.dart'; // Penting untuk debugPrint
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/models/admin/jadwal_detail_model.dart';

class JadwalDetailService {
 Future<List<JadwalMataKuliah>> getJadwalDetail(String namaKelas) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  // Ganti parameter sesuai kebutuhan API Anda (cek apakah perlu id_kelas atau nama_kelas)
  // Jika API Anda mengharapkan ID, pastikan Anda mengirim ID, bukan nama.
  final url = Uri.parse("${ApiConfig.kelasMk}?nama_kelas=$namaKelas");
  
  debugPrint("Memanggil URL: $url");

  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  debugPrint("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    
    // Cek apakah data dibungkus dalam key 'data'
    List<dynamic> data = decoded['data'] ?? [];
    return data.map((json) => JadwalMataKuliah.fromJson(json)).toList();
  } else {
    throw Exception("Gagal mengambil data. Status: ${response.statusCode}");
  }
}
}