import '../../models/mahasiswa/status_semester_model.dart';

class StatusSemesterService {
  Future<List<StatusSemesterModel>> getRiwayatSemester() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      StatusSemesterModel(
        semester: "Semester 4",
        tahunAkademik: "2025/2026 Genap",
        status: "Aktif",
        ips: "3.86",
        ipk: "3.75",
        sks: "20",
      ),
      StatusSemesterModel(
        semester: "Semester 3",
        tahunAkademik: "2025/2026 Ganjil",
        status: "Aktif",
        ips: "3.70",
        ipk: "3.70",
        sks: "22",
      ),
      StatusSemesterModel(
        semester: "Semester 2",
        tahunAkademik: "2024/2025 Genap",
        status: "Aktif",
        ips: "3.65",
        ipk: "3.68",
        sks: "21",
      ),
      StatusSemesterModel(
        semester: "Semester 1",
        tahunAkademik: "2024/2025 Ganjil",
        status: "Aktif",
        ips: "3.50",
        ipk: "3.50",
        sks: "22",
      ),
    ];
  }
}