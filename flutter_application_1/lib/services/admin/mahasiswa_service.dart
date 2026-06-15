import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/admin/mahasiswa_model.dart';
import '../../config/api_config.dart';

class MahasiswaService {
  
  // ==========================================
  // 1. GET DATA MAHASISWA DARI API (READ)
  // ==========================================
  Future<List<MahasiswaModel>> getMahasiswa() async {
    // Ambil token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesi telah habis. Silakan login kembali.");
    }

    try {
      // Panggil API GET menggunakan ApiConfig
      final response = await http.get(
        Uri.parse(ApiConfig.mahasiswa),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Asumsi data array berada di dalam key 'data' (standar response Laravel)
        final List<dynamic> dataList = responseData['data'] ?? [];

        // Mapping response JSON ke dalam List<MahasiswaModel>
        return dataList.map((json) {
          return MahasiswaModel(
            nim: json['nim']?.toString() ?? "-",
            nama: json['nama'] ?? json['name'] ?? "Tanpa Nama",
            // Sesuaikan key json ini dengan response sebenarnya dari backend teman Anda
            jurusan: json['prodi'] != null ? json['prodi']['nama_prodi'] : (json['jurusan'] ?? "-"),
            semester: json['semester'] != null ? "Semester ${json['semester']}" : "Semester -",
            status: json['status'] ?? "AKTIF",
          );
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception("Akses ditolak (401). Silakan login ulang.");
      } else {
        throw Exception("Gagal mengambil data mahasiswa (Status: ${response.statusCode})");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan jaringan: ${e.toString().replaceAll("Exception: ", "")}");
    }
  }

  // ==========================================
  // 2. HAPUS DATA MAHASISWA DARI API (DELETE)
  // ==========================================
  Future<void> deleteMahasiswa(String nim) async {
    // Ambil token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesi telah habis. Silakan login kembali.");
    }

    try {
      // Panggil API DELETE menggunakan rute dinamis dari ApiConfig
      final response = await http.delete(
        Uri.parse(ApiConfig.deleteMahasiswa(nim)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Status 200 (OK) atau 204 (No Content) menandakan sukses
      if (response.statusCode != 200 && response.statusCode != 204) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Gagal menghapus data.");
      }
    } catch (e) {
       throw Exception("Terjadi kesalahan jaringan: ${e.toString().replaceAll("Exception: ", "")}");
    }
  }
  // ==========================================
  // 3. DETAIL DATA MAHASISWA DARI API (Detail)
  // ==========================================
  // Lokasi: lib/services/admin/mahasiswa_service.dart

Future<MahasiswaModel> getDetailMahasiswa(String nim) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception("Sesi telah habis. Silakan login kembali.");
  }

  final response = await http.get(
    // 🔥 Panggil endpoint detail
    Uri.parse(ApiConfig.detailMahasiswa(nim)),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final json = responseData['data']; // Sesuaikan dengan struktur JSON backend Anda

    return MahasiswaModel(
      nim: json['nim']?.toString() ?? "-",
      nama: json['nama'] ?? "Tanpa Nama",
      jurusan: json['prodi'] != null ? json['prodi']['nama_prodi'] : (json['jurusan'] ?? "-"),
      semester: json['semester'] != null ? "Semester ${json['semester']}" : "Semester -",
      status: json['status'] ?? "AKTIF",
    );
  } else {
    throw Exception("Gagal memuat detail mahasiswa");
  }
}
}