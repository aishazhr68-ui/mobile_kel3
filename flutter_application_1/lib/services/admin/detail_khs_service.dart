// Lokasi: lib/services/student_detail_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/admin/detail_khs_model.dart'; // Sesuaikan path

class StudentDetailService {
  Future<StudentDetailModel> getDetailMahasiswa(String nim) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data sesuai desain gambar
    return StudentDetailModel(
      nama: "Aufa Qonita Salsabila",
      nim: "C030324011",
      programStudi: "D3 Teknik Informatika",
      kelas: "TI-4C",
      dosenPembimbing: "Herlinawati, S.Ag., M.Pd.",
      status: "AKTIF",
      courses: [
        CourseModel(
          namaMataKuliah: "Administrasi Database",
          kode: "C0320401",
          sks: 3,
          jadwal: "Rabu, 13.30 - 17.55",
          dosen: "Rahimi Fitri, S.Kom, M.Kom",
          icon: Icons.storage,
        ),
        CourseModel(
          namaMataKuliah: "Keamanan Jaringan",
          kode: "C0320402",
          sks: 3,
          jadwal: "Jumat, 08.00 - 12.10",
          dosen: "Dr. Kun N. P. P., S. T., M.Kom.",
          icon: Icons.security,
        ),
        CourseModel(
          namaMataKuliah: "Metode Numerik",
          kode: "C0320403",
          sks: 2,
          jadwal: "Kamis, 08.00 - 10.30",
          dosen: "Nitami L., P., S. Kom. M, Kom.",
          icon: Icons.functions,
        ),
        CourseModel(
          namaMataKuliah: "Pemrograman Perangkat Bergerak",
          kode: "C0320404",
          sks: 3,
          jadwal: "Senin, 14.20 - 19.30",
          dosen: "Arifin Noor A, S. ST., M. T.",
          icon: Icons.phone_android,
        ),
        CourseModel(
          namaMataKuliah: "Pemrograman Web",
          kode: "C0320405",
          sks: 3,
          jadwal: "Rabu, 08.00 - 12.10",
          dosen: "Agus S. B. N., S. T., M. Kom.",
          icon: Icons.language,
        ),
      ],
    );
  }
}