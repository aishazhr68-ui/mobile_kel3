import '../../models/mahasiswa/penilaian_detail_model.dart';

class PenilaianDetailService {
  Future<PenilaianDetailModel> getDetailNilai(
    String namaMatkul,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return PenilaianDetailModel(
      namaMatkul: namaMatkul,
      kodeMatkul: "C030320403",
      dosen: "Nitami Lestari Putri, S.Kom., M.Kom.",
      nidn: "NIDN 24032403",

      rincian: [
        KomponenNilaiModel(
          komponen: "Tugas",
          bobot: 20,
          nilai: 70,
          akhir: 14,
        ),
        KomponenNilaiModel(
          komponen: "Aktivitas",
          bobot: 20,
          nilai: 65,
          akhir: 13,
        ),
        KomponenNilaiModel(
          komponen: "UTS",
          bobot: 20,
          nilai: 68,
          akhir: 13.6,
        ),
        KomponenNilaiModel(
          komponen: "UAS",
          bobot: 40,
          nilai: 76,
          akhir: 30,
        ),
      ],

      totalNilai: 71.2,
      grade: "B",
    );
  }
}