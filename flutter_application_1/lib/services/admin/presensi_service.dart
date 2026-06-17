import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_config.dart';
import '../../models/admin/kelas_presensi_model.dart';

class PresensiService {
  
  // 1. Mengambil Daftar Kelas (Untuk Halaman Presensi Awal)
  Future<List<KelasPresensiModel>> getDaftarKelas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan, silakan login kembali.");

    try {
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
        return dataList.map((json) => KelasPresensiModel(
          id: json['id_kelas']?.toString() ?? "-",
          kelas: json['kelas_nama'] ?? "-",
        )).toList();
      } else {
        throw Exception("Gagal memuat daftar kelas");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan jaringan: $e");
    }
  }

  // 2. Mengambil Daftar Matakuliah Per Kelas
  Future<List<dynamic>> getJadwalPerKelas(String idKelas) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Sesi telah habis.");

    try {
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
        return responseData['data'] ?? []; 
      } else {
        throw Exception("Gagal memuat daftar matakuliah");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan jaringan: $e");
    }
  }

  // 3. Mengambil Rekap Presensi Mahasiswa per MK
  Future<List<dynamic>> getRekapPresensiMahasiswa(String idMk) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Sesi telah habis.");

    try {
      // Menggunakan endpoint roster karena rekap-mahasiswa tidak ada di backend
      final String url = '${ApiConfig.presensi}/roster?id_kelas_mk=$idMk&pertemuan_ke=1';

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

  // 4. Mengambil Detail Presensi 1 Mahasiswa
  Future<Map<String, dynamic>> getDetailPresensiMahasiswa(String idMk, String nim) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Sesi telah habis.");

    try {
      final String url = '${ApiConfig.presensi}/detail-mahasiswa?id_mk=$idMk&nim=$nim';

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
        return responseData['data'] ?? {};
      } else {
        throw Exception("Gagal memuat detail presensi");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan jaringan: $e");
    }
  }
}