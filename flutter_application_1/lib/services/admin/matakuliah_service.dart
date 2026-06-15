import '../../models/admin/matakuliah_model.dart';

class MatakuliahService {

  Future<List<MatakuliahModel>>
      getMatakuliah() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [
      MatakuliahModel(
        kode: "IF401",
        nama: "Pemrograman Mobile",
        kelas: "TI-4C",
        dosen: "Dr. Ahmad",
      ),
    ];
  }
}