import '../../models/admin/nilai_model.dart';

class NilaiService {

  Future<List<NilaiModel>>
      getNilaiMahasiswa() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [
      NilaiModel(
        nim: "C030324003",
        nama: "Ahmad Ridho Kurniawan",
        nilai: 80,
        grade: "A",
      ),
    ];
  }
}