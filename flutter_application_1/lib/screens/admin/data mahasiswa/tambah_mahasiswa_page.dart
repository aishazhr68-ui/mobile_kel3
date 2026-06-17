import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/services/admin/mahasiswa_service.dart';

class TambahMahasiswaPage extends StatefulWidget {
  const TambahMahasiswaPage({super.key});

  @override
  State<TambahMahasiswaPage> createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();

  String? selectedGender;
  String? selectedJurusan;
  String? selectedProdi;
  String? selectedKelas;
  String? selectedSemester;
  String? selectedTahunAkademik;

  bool isSaving = false; 
  bool isFetchingMasterData = true; 

  List<dynamic> listJurusan = [];
  List<dynamic> listProdi = [];
  List<dynamic> listKelas = [];
  List<dynamic> listTahunAkademik = [];
  
  final List<String> listSemester = ["1", "2", "3", "4", "5", "6", "7", "8"];

  @override
  void initState() {
    super.initState();
    _fetchDataMaster(); 
  }

  @override
  void dispose() {
    nimController.dispose();
    namaController.dispose();
    emailController.dispose();
    noHpController.dispose();
    super.dispose();
  }

  Future<void> _fetchDataMaster() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      Future<List<dynamic>> safeFetch(String url, String namaData) async {
        try {
          final response = await http.get(Uri.parse(url), headers: headers);
          
          if (response.statusCode == 200) {
            if (response.body.trim().startsWith('<')) {
              print("🚨 SERVER ERROR (HTML) DI API $namaData");
              return []; 
            }
            final decoded = jsonDecode(response.body);
            return decoded['data'] ?? [];
          } else {
            print("🚨 ERROR $namaData: Status ${response.statusCode}");
            return [];
          }
        } catch (e) {
          print("🚨 CATCH ERROR $namaData: $e");
          return [];
        }
      }

      listJurusan = await safeFetch(ApiConfig.jurusan, "JURUSAN");
      listProdi = await safeFetch(ApiConfig.prodi, "PRODI");
      listKelas = await safeFetch(ApiConfig.getKelasJadwal, "KELAS"); 
      listTahunAkademik = await safeFetch(ApiConfig.tahunAkademik, "TAHUN AKADEMIK");

    } catch (e) {
      debugPrint("Error jaringan saat fetch data master: $e");
    } finally {
      if (mounted) {
        setState(() {
          isFetchingMasterData = false;
        });
      }
    }
  }

  Future<void> _simpanData() async {
    if (nimController.text.isEmpty || namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua field yang wajib (*)")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final body = {
        "NIM": nimController.text.trim(),
        "NAMA": namaController.text.trim(),
        "EMAIL": emailController.text.trim(),
        "NO_HP": noHpController.text.trim(),
        "ID_JK": selectedGender == "Laki-laki" ? 1 : 0,
        "ID_USER": 1,
        "ID_STATUS_MHS": 1, // Aktif
        "ID_PRODI": int.tryParse(selectedProdi ?? "") ?? selectedProdi,
      };

      await MahasiswaService().addMahasiswa(body);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil ditambahkan!")));
      Navigator.pop(context, true); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 60,
        titleSpacing: -5,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Kembali", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w500)),
      ),
      
      body: isFetchingMasterData 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF2563EB)),
                SizedBox(height: 16),
                Text("Mengambil data dari server...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ) 
        : SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          children: [
            const Text("Tambah Mahasiswa", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black)),
            const SizedBox(height: 10),
            const Text("Lengkapi formulir di bawah ini untuk mendaftarkan mahasiswa baru.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            _sectionCard(
              title: "Informasi Pribadi",
              icon: Icons.person_outline,
              children: [
                _input("NIM *", "Masukkan NIM", controller: nimController),
                _input("Nama Lengkap *", "Masukkan Nama Lengkap", controller: namaController),
                _input("Email *", "contoh@gmail.com", icon: Icons.mail_outline, controller: emailController),
                _input("No Hp *", "08xxxxxxxxxx", icon: Icons.phone_outlined, controller: noHpController),
                _dropdownGender(),
              ],
            ),
            const SizedBox(height: 20),

            _sectionCard(
              title: "Data Akademik",
              icon: Icons.school_outlined,
              children: [
                _dropdownApi("Jurusan *", "Pilih Jurusan", value: selectedJurusan, items: listJurusan, 
                  onChanged: (val) => setState(() => selectedJurusan = val)),
                
                _dropdownApi("Program Studi *", "Pilih Program Studi", value: selectedProdi, items: listProdi, 
                  onChanged: (val) => setState(() => selectedProdi = val)),

                Row(
                  children: [
                    Expanded(child: _dropdownApi("Kelas *", "Pilih Kelas", value: selectedKelas, items: listKelas, 
                      onChanged: (val) => setState(() => selectedKelas = val))),
                    const SizedBox(width: 10),
                    Expanded(child: _dropdownStatic("Semester *", "Pilih Semester", value: selectedSemester, items: listSemester, 
                      onChanged: (val) => setState(() => selectedSemester = val))),
                  ],
                ),
                
                _dropdownApi("Tahun Akademik *", "Pilih Tahun Akademik", value: selectedTahunAkademik, items: listTahunAkademik, 
                  onChanged: (val) => setState(() => selectedTahunAkademik = val)),
              ],
            ),

            const SizedBox(height: 20),
            const Center(child: Text("© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.", style: TextStyle(color: Colors.grey, fontSize: 12))),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey, side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _simpanData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 16, color: Colors.white),
                              SizedBox(width: 6),
                              Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: const Color(0xFF2563EB), size: 18), const SizedBox(width: 6), Text(title, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _input(String label, String hint, {IconData? icon, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(text: label.replaceAll(" *", ""), style: const TextStyle(color: Colors.black), children: const [TextSpan(text: " *", style: TextStyle(color: Colors.red))])),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint, prefixIcon: icon != null ? Icon(icon, size: 18, color: Colors.grey) : null,
              filled: true, fillColor: const Color(0xFFF8FAFC),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB))),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 PERBAIKAN: Fungsi ini sekarang pintar membaca format JSON yang unik dari API Anda
  Widget _dropdownApi(String label, String hint, {required String? value, required List<dynamic> items, required ValueChanged<String?> onChanged}) {
    // Kita filter item yang null atau duplikat (terutama untuk kelas)
    final uniqueItems = <String, dynamic>{};
    for (var item in items) {
      if (item == null) continue;
      
      // Mengambil ID (Bisa dari root, bisa dari dalam objek 'kelas')
      String id = item['id_jurusan']?.toString() ?? 
                  item['id_prodi']?.toString() ?? 
                  item['kelas']?['id_kelas']?.toString() ?? // Khusus Kelas MK
                  item['id_kelas']?.toString() ?? 
                  item['id_tahun_akademik']?.toString() ?? 
                  item['id']?.toString() ?? "";

      // Mencegah duplikasi ID yang sama masuk ke dropdown
      if (id.isNotEmpty) {
        uniqueItems[id] = item;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(text: label.replaceAll(" *", ""), style: const TextStyle(color: Colors.black), children: const [TextSpan(text: " *", style: TextStyle(color: Colors.red))])),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: DropdownButton<String>(
              value: value, isExpanded: true, underline: const SizedBox(), icon: const Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(hint, style: const TextStyle(color: Colors.grey)),
              items: uniqueItems.values.map((item) {
                
                // Ambil ID lagi untuk value dropdown
                String id = item['id_jurusan']?.toString() ?? 
                            item['id_prodi']?.toString() ?? 
                            item['kelas']?['id_kelas']?.toString() ?? 
                            item['id_kelas']?.toString() ?? 
                            item['id_tahun_akademik']?.toString() ?? 
                            item['id']?.toString() ?? "";

                // Ambil Nama sesuai JSON Anda
                String nama = item['nama_jurusan'] ?? 
                              item['nama_prodi'] ?? 
                              item['kelas']?['kelas_nama'] ?? // Khusus Kelas MK
                              item['kelas_nama'] ?? 
                              item['nama_kelas'] ?? 
                              item['nama_tahun_akademik'] ?? 
                              item['nama'] ?? "Tanpa Nama";

                return DropdownMenuItem<String>(value: id, child: Text(nama));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownStatic(String label, String hint, {required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(text: label.replaceAll(" *", ""), style: const TextStyle(color: Colors.black), children: const [TextSpan(text: " *", style: TextStyle(color: Colors.red))])),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: DropdownButton<String>(
              value: value, isExpanded: true, underline: const SizedBox(), icon: const Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(hint, style: const TextStyle(color: Colors.grey)),
              items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownGender() {
    return _dropdownStatic("Jenis Kelamin *", "Pilih Gender", value: selectedGender, items: ["Laki-laki", "Perempuan"], onChanged: (val) => setState(() => selectedGender = val));
  }
}