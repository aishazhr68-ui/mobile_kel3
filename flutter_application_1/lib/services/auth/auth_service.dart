import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/admin/user_model.dart';
import '../../config/api_config.dart';

class AuthService {
  
  Future<UserModel> login(String email, String password) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      // ========================================================
      // 1. PERCOBAAN PERTAMA: LOGIN SEBAGAI ADMIN (PORT 9002)
      // ========================================================
      final adminResponse = await http.post(
        Uri.parse(ApiConfig.login),
        headers: headers,
        body: body,
      );

      debugPrint("=== STATUS ADMIN: ${adminResponse.statusCode} ===");
      debugPrint("=== BODY ADMIN: ${adminResponse.body} ===");

      if (adminResponse.statusCode == 200) {
        final adminToken = _extractTokenSafe(adminResponse.body);
        if (adminToken.isNotEmpty) {
          return _parseUserDataSafe(adminResponse.body, defaultRole: "admin_mahasiswa", token: adminToken);
        }
      }

      // ========================================================
      // 2. PERCOBAAN KEDUA: LOGIN SEBAGAI MAHASISWA (PORT 9003)
      // (Jalur ini diambil jika login Admin Gagal)
      // ========================================================
      debugPrint("--- Login Admin gagal, mencoba jalur Mahasiswa ---");
      
      final mhsResponse = await http.post(
        Uri.parse(ApiConfig.loginMahasiswa),
        headers: headers,
        body: body,
      );
      
      debugPrint("=== STATUS MHS: ${mhsResponse.statusCode} ===");
      debugPrint("=== BODY MHS: ${mhsResponse.body} ===");

      if (mhsResponse.statusCode == 200) {
        final mhsToken = _extractTokenSafe(mhsResponse.body);
        if (mhsToken.isNotEmpty) {
          return _parseUserDataSafe(mhsResponse.body, defaultRole: "mahasiswa", token: mhsToken);
        }
      }

      // ========================================================
      // 3. JIKA KEDUANYA GAGAL
      // ========================================================
      String errorMessage = "Email atau password salah.";
      
      // Mengambil pesan error dari Admin atau Mahasiswa dengan aman
      errorMessage = _extractErrorMessage(mhsResponse.body) 
                  ?? _extractErrorMessage(adminResponse.body) 
                  ?? errorMessage;
                  
      throw Exception(errorMessage);

    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // Helper untuk mengekstrak token secara aman (Tahan Crash)
  String _extractTokenSafe(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      
      // Jika API hanya mengembalikan String token murni
      if (decoded is String) return decoded; 
      
      if (decoded is Map<String, dynamic>) {
        if (decoded['success'] == false) return "";
        
        final data = decoded.containsKey('data') ? decoded['data'] : decoded;
        
        if (data is Map<String, dynamic>) {
          return (data['access_token'] ?? data['token'] ?? "").toString();
        } else if (data is String) {
          // Jika key 'data' ternyata berisi token langsung
          return data;
        }
      }
    } catch (e) {
      // Jika responseBody bukan JSON (contoh: plain text JWT token)
      if (responseBody.isNotEmpty && !responseBody.contains("{")) {
        return responseBody;
      }
    }
    return "";
  }

  // Helper untuk mem-parsing data User agar aman (Defensive Programming)
  UserModel _parseUserDataSafe(String responseBody, {required String defaultRole, required String token}) {
    try {
      final decoded = jsonDecode(responseBody);
      
      if (decoded is Map<String, dynamic>) {
        final data = decoded.containsKey('data') ? decoded['data'] : decoded;
        
        if (data is Map<String, dynamic>) {
          // Kadang data user ada di dalam key 'user', kadang rata langsung di 'data'
          final userData = data['user'] ?? data; 

          // Menangani format Role dari Laravel Spatie
          String userRole = defaultRole;
          if (userData['roles'] != null && userData['roles'] is List && (userData['roles'] as List).isNotEmpty) {
            var roleItem = userData['roles'][0];
            userRole = (roleItem is Map) ? (roleItem['name']?.toString() ?? defaultRole) : roleItem.toString();
          }

          return UserModel(
            // Cek huruf kecil (admin) maupun huruf besar (mahasiswa)
            id: int.tryParse(userData['id']?.toString() ?? userData['ID_USER']?.toString() ?? '0') ?? 0,
            nama: userData['name'] ?? userData['nama'] ?? userData['NAMA'] ?? "User",
            email: userData['email'] ?? userData['EMAIL'] ?? "",
            role: userRole,
            token: token,
          );
        }
      }
    } catch (e) {
      debugPrint("Gagal mem-parsing data user: $e");
    }

    // Fallback darurat jika API ternyata hanya mengembalikan Token, tapi tidak mengirim info user
    return UserModel(
      id: 0,
      nama: "User",
      email: "",
      role: defaultRole,
      token: token,
    );
  }

  // Helper untuk mengekstrak pesan error dengan aman
  String? _extractErrorMessage(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded['message'] ?? decoded['error'];
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}