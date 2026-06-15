import '../../models/mahasiswa/penilaian_matakuliah_model.dart';

class PenilaianMatakuliahService {
  Future<List<PenilaianMatakuliahModel>>
      getDaftarMatakuliah() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return [
      PenilaianMatakuliahModel(
        id: "C0320401",
        namaMatkul: "Administrasi Database",
        dosen: "Rahimi Fitri, S.Kom, M.Kom",
      ),

      PenilaianMatakuliahModel(
        id: "C0320402",
        namaMatkul: "Keamanan Jaringan",
        dosen: "Dr. Kun Nursyafii PP, S.T., M.Kom",
      ),

      PenilaianMatakuliahModel(
        id: "C0320403",
        namaMatkul: "Metode Numerik",
        dosen: "Nitami Lestari Putri, S.Kom., M.Kom",
      ),

      PenilaianMatakuliahModel(
        id: "C0320404",
        namaMatkul: "Pemrograman Perangkat Bergerak",
        dosen: "Arifin Noor Asyikin, S.ST., M.T.",
      ),

      PenilaianMatakuliahModel(
        id: "C0320405",
        namaMatkul: "Pemrograman Web",
        dosen: "Agus Setiyo B.N., S.T., M.Kom",
      ),

      PenilaianMatakuliahModel(
        id: "C0320406",
        namaMatkul:
            "Perancangan Perangkat Lunak Berbasis Objek",
        dosen: "Abdul Kadir, PhD",
      ),

      PenilaianMatakuliahModel(
        id: "C0320407",
        namaMatkul: "Kecerdasan Buatan",
        dosen: "Yeonie Indrasary",
      ),
    ];
  }
}