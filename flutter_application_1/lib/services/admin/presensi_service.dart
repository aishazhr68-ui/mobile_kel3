import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_config.dart'; // Sesuaikan path jika berbeda
import '../../models/admin/kelas_presensi_model.dart';

class PresensiService {
  
  // =======================================================
  // 1. Mengambil Daftar Kelas (Untuk Halaman Presensi Awal)
  // =======================================================
  Future<List<KelasPresensiModel>> getDaftarKelas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login kembali.");
    }

    try {
      // Memanggil API dari ApiConfig
      final response = await http.get(
        Uri.parse(ApiConfig.getKelasJadwal), 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> dataList = responseData['data'] ?? [];

        // Mapping JSON ke Model
        return dataList.map((json) {
          return KelasPresensiModel(
            // Sesuaikan key json ini dengan response dari backend Anda
            id: json['id_kelas']?.toString() ?? "-",
            kelas: json['nama_kelas'] ?? "-",
          );
        }).toList();
      } else {
        throw Exception("Gagal memuat daftar kelas");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan jaringan: $e");
    }
  }

  // =======================================================
  // 2. Mengambil Daftar Matakuliah Per Kelas (🔥 BARU DITAMBAHKAN)
  // =======================================================
  Future<List<dynamic>> getJadwalPerKelas(String idKelas) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesi telah habis. Silakan login kembali.");
    }

    try {
      // Memanggil API getJadwalPerKelas dengan membawa ID Kelas
      final response = await http.get(
        Uri.parse(ApiConfig.getJadwalPerKelas(idKelas)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Mengembalikan list matakuliah dari JSON data
        return responseData['data'] ?? []; 
      } else {
        throw Exception("Gagal memuat daftar matakuliah untuk kelas ini");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan jaringan: $e");
    }
  }
// =======================================================
  // 3. Mengambil Rekap Mahasiswa per Matakuliah
  // =======================================================
  Future<List<dynamic>> getRekapPresensiMahasiswa(String idMk) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesi telah habis. Silakan login kembali.");
    }

    try {
      // Menembak API Rekap Mahasiswa berdasarkan id_mk
      // Pastikan ApiConfig.presensi sudah terdefinisi di api_config.dart Anda
      final String url = '${ApiConfig.presensi}/rekap-mahasiswa?id_mk=$idMk';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        throw Exception("Gagal memuat rekap mahasiswa");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan jaringan: $e");
    }
  }

}