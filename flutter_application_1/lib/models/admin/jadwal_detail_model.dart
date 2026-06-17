import 'package:flutter/material.dart';

class JadwalMataKuliah {
  final String namaMataKuliah;
  final String hari;
  final String waktu;
  final String ruang;
  final String namaDosen;
  final int sks;

  JadwalMataKuliah({
    required this.namaMataKuliah,
    required this.hari,
    required this.waktu,
    required this.ruang,
    required this.namaDosen,
    required this.sks,
  });

  factory JadwalMataKuliah.fromJson(Map<String, dynamic> json) {
    debugPrint("Mapping JSON: $json"); 

    // Helper untuk mengambil data relasi (jika API mengirim objek)
    String getRelasi(dynamic field, String key) {
      if (field is Map) return field[key]?.toString() ?? "-";
      return field?.toString() ?? "-";
    }

    return JadwalMataKuliah(
      // Coba akses key 'kurikulum_mk' -> 'mata_kuliah' -> 'nama_mk', fallback ke 'mata_kuliah' -> 'nama_mk', lalu 'nama_mk'
      namaMataKuliah: json['kurikulum_mk']?['mata_kuliah'] != null
          ? getRelasi(json['kurikulum_mk']?['mata_kuliah'], 'nama_mk')
          : (json['mata_kuliah'] != null 
              ? getRelasi(json['mata_kuliah'], 'nama_mk') 
              : (json['nama_mk']?.toString() ?? "Tanpa Nama")),

      // Coba akses key 'hari', jika tidak ada, ambil langsung dari 'hari'
      hari: json['hari'] != null 
          ? getRelasi(json['hari'], 'nama_hari') 
          : (json['hari']?.toString() ?? "Tidak Diketahui"),

      // Waktu biasanya gabungan waktu_mulai/jam_mulai dan waktu_akhir/jam_selesai
      waktu: "${json['waktu_mulai'] ?? json['jam_mulai'] ?? '00:00'} - ${json['waktu_akhir'] ?? json['jam_selesai'] ?? '00:00'}",

      // Coba akses key 'ruang', jika tidak ada, ambil langsung dari 'ruang'
      ruang: json['ruang'] != null 
          ? getRelasi(json['ruang'], 'nama_ruang') 
          : (json['ruang']?.toString() ?? "-"),

      // Coba akses key 'dosen', jika tidak ada, ambil langsung dari 'dosen'
      namaDosen: json['dosen'] != null 
          ? getRelasi(json['dosen'], 'nama_pegawai') 
          : (json['dosen']?.toString() ?? "-"),

      sks: int.tryParse(json['kurikulum_mk']?['mata_kuliah']?['sks']?.toString() ?? json['sks']?.toString() ?? "0") ?? 0,
    );
  }
}