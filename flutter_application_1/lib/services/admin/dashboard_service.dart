// Lokasi: lib/services/admin/dashboard_admin_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/models/admin/dashboard_model.dart';

class DashboardAdminService {
  Future<DashboardModel> getDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Menggunakan endpoint Mobile yang sudah kita siapkan di ApiConfig
    final url = Uri.parse(ApiConfig.dashboardAdminMobile);

    debugPrint("Memanggil API Dashboard: $url");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("Status Dashboard: ${response.statusCode}");
      debugPrint("Body Dashboard: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        // Data dari Laravel biasanya dibungkus di dalam key "data"
        final data = decoded['data'] ?? {};
        
        return DashboardModel.fromJson(data);
      } else {
        throw Exception("Gagal memuat dashboard. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error jaringan atau server: $e");
    }
  }
}