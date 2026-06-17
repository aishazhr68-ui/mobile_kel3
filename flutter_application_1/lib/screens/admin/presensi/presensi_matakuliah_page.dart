import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'presensi_metode_numerik_page.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/config/api_config.dart';

class PresensiMatakuliahPage extends StatefulWidget {
  final String idKelas;
  final String namaKelas;

  const PresensiMatakuliahPage({
    Key? key,
    required this.idKelas, 
    required this.namaKelas,
  }) : super(key: key);

  @override
  _PresensiMatakuliahPageState createState() => _PresensiMatakuliahPageState();
}

class _PresensiMatakuliahPageState extends State<PresensiMatakuliahPage> {
  String sortById = "ID Matakuliah";
  bool isLoading = true;
  List<Map<String, dynamic>> daftarMatakuliah = []; 

  @override
  void initState() {
    super.initState();
    loadDataMatakuliah();
  }

  Future<void> loadDataMatakuliah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // 1. Ambil Data Dosen (Kamus NIP -> Nama)
      final resDosen = await http.get(Uri.parse("https://api-pegawai-4c.akufarish.my.id:9001/api/dosen"), headers: headers);
      Map<String, String> mapNamaDosen = {};
      if (resDosen.statusCode == 200) {
        List<dynamic> listDosen = jsonDecode(resDosen.body);
        for (var d in listDosen) {
          mapNamaDosen[d['NIP'].toString().trim().toLowerCase()] = d['NAMA_PEGAWAI'] ?? "Nama Tidak Diketahui";
        }
      }

      // 2. Ambil Kelas MK
      final resKelasMk = await http.get(Uri.parse(ApiConfig.kelasMk), headers: headers);
      List<Map<String, dynamic>> hasil = [];

      if (resKelasMk.statusCode == 200) {
        final decoded = jsonDecode(resKelasMk.body);
        List<dynamic> listKelasMk = decoded['data'] ?? [];

        for (var item in listKelasMk) {
          if (item['id_kelas']?.toString() == widget.idKelas.toString()) {
            String id = item['id_kelas_mk']?.toString() ?? "-";
            String nama = item['kurikulum_mk']?['mata_kuliah']?['nama_mk'] ?? item['tema'] ?? "-";
            String nip = item['nip']?.toString().trim().toLowerCase() ?? "";
            
            hasil.add({
              "idMk": id,
              "namaMk": nama,
              "namaDosen": mapNamaDosen[nip] ?? "NIP: ${item['nip']}",
            });
          }
        }
      }

      if (mounted) {
        setState(() {
          daftarMatakuliah = hasil;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logika Sorting
    List<Map<String, dynamic>> sortedList = List.from(daftarMatakuliah);
    if (sortById == "Nama Matakuliah") {
      sortedList.sort((a, b) => a['namaMk'].compareTo(b['namaMk']));
    } else {
      sortedList.sort((a, b) => a['idMk'].compareTo(b['idMk']));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, titleSpacing: -5,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)), onPressed: () => Navigator.pop(context)),
        title: const Text("Kembali", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 15)),
      ),
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text("Presensi Mahasiswa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                const SizedBox(height: 20),
                
                // Card Tabel
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Daftar Matakuliah ${widget.namaKelas}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            DropdownButton<String>(
                              value: sortById,
                              items: ["ID Matakuliah", "Nama Matakuliah"].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 11)))).toList(),
                              onChanged: (val) => setState(() => sortById = val!),
                            ),
                          ],
                        ),
                      ),
                      Container(color: const Color(0xFFEFF6FF), padding: const EdgeInsets.all(16), child: Row(children: const [Expanded(child: Text("ID")), Expanded(child: Text("MATAKULIAH")), Expanded(child: Text("DOSEN"))])),
                      ...sortedList.map((item) => _buildMatakuliahRow(item['idMk'], item['namaMk'], item['namaDosen'], () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PresensiMetodeNumerikPage(idMk: item['idMk'], namaMk: item['namaMk'], namaKelas: widget.namaKelas)));
                      })),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildMatakuliahRow(String id, String matakuliah, String dosen, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
        child: Row(children: [Expanded(child: Text(id)), Expanded(child: Text(matakuliah)), Expanded(child: Text(dosen))]),
      ),
    );
  }
}