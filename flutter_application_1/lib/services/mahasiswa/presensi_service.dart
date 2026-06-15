import 'package:flutter_application_1/models/mahasiswa/kelas_presensi_model.dart';

class PresensiService {
  Future<List<KelasPresensiModel>>
      getDaftarKelas() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [
      KelasPresensiModel(
        id: "AK01",
        kelas: "AK-2A",
      ),
      KelasPresensiModel(
        id: "MI01",
        kelas: "MI-2A",
      ),
      KelasPresensiModel(
        id: "MI02",
        kelas: "MI-4B",
      ),
      KelasPresensiModel(
        id: "TI01",
        kelas: "TI-4C",
      ),
    ];
  }
}