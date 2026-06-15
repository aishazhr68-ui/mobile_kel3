import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/admin/user_model.dart';
import '../../config/api_config.dart'; 

class AuthService {
  Future<UserModel> login(String email, String password) async {
    final url = Uri.parse(ApiConfig.login);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // WAJIB untuk mencegah redirect HTML
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Menyesuaikan dengan struktur response dari server 9002
        final Map<String, dynamic> data = responseData.containsKey('data') 
            ? responseData['data'] 
            : responseData;

        final userData = data['user'];
        // Menggunakan 'access_token' sesuai balasan dari API 9002
        final token = data['access_token'] ?? data['token'];

        // Mengambil role pertama jika berbentuk array
        String userRole = "mahasiswa";
        if (userData['roles'] != null && userData['roles'].isNotEmpty) {
          userRole = userData['roles'][0].toString();
        }

        return UserModel(
          id: int.tryParse(userData['id'].toString()) ?? 0,
          nama: userData['name'] ?? userData['nama'] ?? "User",
          email: userData['email'] ?? "",
          role: userRole, 
          token: token ?? "",
        );
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Email atau Password salah.");
      }
    } catch (e) {
      throw Exception("Gagal terhubung ke server: ${e.toString().replaceAll("Exception: ", "")}");
    }
  }
}