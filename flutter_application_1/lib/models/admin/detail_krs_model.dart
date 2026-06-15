// Lokasi: lib/models/student_detail_model.dart
import 'package:flutter/material.dart';

class CourseModel {
  final String namaMataKuliah;
  final String kode;
  final int sks;
  final String jadwal;
  final String dosen;
  final IconData icon; // Untuk membedakan ikon tiap matkul

  CourseModel({
    required this.namaMataKuliah,
    required this.kode,
    required this.sks,
    required this.jadwal,
    required this.dosen,
    required this.icon,
  });
}

class StudentDetailModel {
  final String nama;
  final String nim;
  final String programStudi;
  final String kelas;
  final String dosenPembimbing;
  final String status;
  final List<CourseModel> courses;

  StudentDetailModel({
    required this.nama,
    required this.nim,
    required this.programStudi,
    required this.kelas,
    required this.dosenPembimbing,
    required this.status,
    required this.courses,
  });

  int get totalSks {
    return courses.fold(0, (sum, item) => sum + item.sks);
  }
}