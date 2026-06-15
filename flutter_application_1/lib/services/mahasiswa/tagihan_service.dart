import 'package:flutter_application_1/models/mahasiswa/tagihan_model.dart';

class TagihanService {
  Future<List<TagihanModel>> getTagihan() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      TagihanModel(
        namaTagihan: 'Uang Kuliah Tunggal (UKT)',
        jatuhTempo: '1 Februari 2026',
        nominal: 2900000,
      ),
    ];
  }

  Future<List<TagihanModel>> getTagihanKosong() async {
    await Future.delayed(const Duration(seconds: 1));

    return [];
  }
}