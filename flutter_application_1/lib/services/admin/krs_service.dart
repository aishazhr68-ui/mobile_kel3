import '../../models/admin/krs_model.dart';

class KrsService {
  Future<List<KrsModel>> getKrs() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

 return [
  KrsModel(id: "AK01", kelas: "AK-2A", hadir: 32, izin: 2),
  KrsModel(id: "MI01", kelas: "MI-2A", hadir: 32, izin: 2),
  KrsModel(id: "MI02", kelas: "MI-4B", hadir: 32, izin: 2),
  KrsModel(id: "TI01", kelas: "TI-4C", hadir: 32, izin: 2),
  KrsModel(id: "TL01", kelas: "TL-2B", hadir: 32, izin: 2),
  KrsModel(id: "TP01", kelas: "TP-6A", hadir: 32, izin: 2),
  KrsModel(id: "AK02", kelas: "AK-4A", hadir: 30, izin: 1),
  KrsModel(id: "TI02", kelas: "TI-6B", hadir: 31, izin: 0),
];
  }
}