import '../../models/mahasiswa/presensi_detail_matkul_model.dart';

class PresensiDetailMatkulService {
  Future<List<DetailSesiPresensiModel>> getDetailPresensi(
      String namaMatkul) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return [
      DetailSesiPresensiModel(
        nomorSesi: 1,
        tanggal: "Senin, 9 Februari 2026",
        waktu: "09:40 - 12:10 WIB",
        ruang: "H-203",
        materi:
            "Pengenalan konsep dasar perancangan perangkat lunak",
        dosen: "ABDUL KADIR, PhD",
        status: "HADIR",
      ),

      DetailSesiPresensiModel(
        nomorSesi: 2,
        tanggal: "Senin, 23 Februari 2026",
        waktu: "09:40 - 12:10 WIB",
        ruang: "H-203",
        materi:
            "Use Case Diagram dan Analisis Kebutuhan",
        dosen: "ABDUL KADIR, PhD",
        status: "HADIR",
      ),

      DetailSesiPresensiModel(
        nomorSesi: 3,
        tanggal: "Senin, 2 Maret 2026",
        waktu: "09:40 - 12:10 WIB",
        ruang: "H-203",
        materi:
            "Perancangan Class Diagram",
        dosen: "ABDUL KADIR, PhD",
        status: "HADIR",
      ),

      DetailSesiPresensiModel(
        nomorSesi: 4,
        tanggal: "Senin, 9 Maret 2026",
        waktu: "09:40 - 12:10 WIB",
        ruang: "H-203",
        materi:
            "Implementasi Class Diagram",
        dosen: "ABDUL KADIR, PhD",
        status: "HADIR",
      ),

      DetailSesiPresensiModel(
        nomorSesi: 5,
        tanggal: "Senin, 16 Maret 2026",
        waktu: "09:40 - 12:10 WIB",
        ruang: "H-203",
        materi:
            "Sequence Diagram",
        dosen: "ABDUL KADIR, PhD",
        status: "HADIR",
      ),

      DetailSesiPresensiModel(
        nomorSesi: 6,
        tanggal: "Senin, 23 Maret 2026",
        waktu: "09:40 - 12:10 WIB",
        ruang: "H-203",
        materi:
            "Activity Diagram",
        dosen: "ABDUL KADIR, PhD",
        status: "ALFA",
      ),
    ];
  }
}