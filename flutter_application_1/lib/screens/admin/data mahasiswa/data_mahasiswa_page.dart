import 'package:flutter/material.dart';
import 'tambah_mahasiswa_page.dart';
import 'detail_mahasiswa_page.dart';
import 'edit_mahasiswa_page.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/models/admin/mahasiswa_model.dart';
import '../../../services/admin/mahasiswa_service.dart';
import 'package:flutter_application_1/widgets/admin/student_card.dart';



class DataMahasiswaPage extends StatefulWidget {
  const DataMahasiswaPage({super.key});

  @override
  State<DataMahasiswaPage> createState() => _DataMahasiswaPageState();
}

class _DataMahasiswaPageState extends State<DataMahasiswaPage> {
  bool isLoading = true;
  List<MahasiswaModel> mahasiswa = [];
  final MahasiswaService mahasiswaService = MahasiswaService();
  int limit = 2;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ================= FUNGSI LOAD DATA =================
  Future<void> loadData() async {
    // Set loading ke true agar muncul indikator saat refresh data setelah hapus
    setState(() => isLoading = true); 
    try {
      final data = await mahasiswaService.getMahasiswa();
      setState(() {
        mahasiswa = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal memuat data: ${e.toString().replaceAll('Exception: ', '')}")),
         );
      }
    }
  }

  // ================= FUNGSI PROSES HAPUS (API) =================
  Future<void> _prosesHapusMahasiswa(BuildContext context, String nim) async {
    // 1. Tutup pop-up dialog
    Navigator.pop(context);

    // 2. Tampilkan notifikasi proses hapus
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sedang menghapus data..."), duration: Duration(seconds: 1)),
    );

    try {
      // 3. Panggil service API untuk hapus data
      await mahasiswaService.deleteMahasiswa(nim);

      // 4. Jika berhasil, tampilkan pesan sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data mahasiswa berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
        // 5. Muat ulang data agar list mahasiswa ter-update
        loadData();
      }
    } catch (e) {
      // 6. Tangani error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menghapus: ${e.toString().replaceAll('Exception: ', '')}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ================= FUNGSI POP-UP KONFIRMASI HAPUS =================
  void _showDeleteConfirmation(BuildContext context, MahasiswaModel mhs) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Melengkung seperti di gambar
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Warning Merah
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFDC2626), // Merah
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Judul
                const Text(
                  "Hapus Data Mahasiswa?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Deskripsi
                Text(
                  "Apakah Anda yakin ingin menghapus data ${mhs.nama} (${mhs.nim})? Tindakan ini permanen dan tidak dapat dibatalkan.",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Tombol "Ya, Hapus"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48), // Warna merah sesuai gambar
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // 🔥 PANGGIL API HAPUS DISINI
                      _prosesHapusMahasiswa(context, mhs.nim);
                    },
                    child: const Text(
                      "Ya, Hapus",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Tombol "Batal"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx); // Tutup pop-up tanpa melakukan apa-apa
                    },
                    child: const Text(
                      "Batal",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: false,

      // ================= FLOAT BUTTON =================
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFAB(),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const CustomBottomNavBar(),

      // ================= BODY =================
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            const SizedBox(height: 20),

            // ===== HEADER =====
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage("assets/logo_poliban.png"),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "SIMPADU",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      "ADMIN DASHBOARD",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===== TITLE =====
            const Text(
              "Data Mahasiswa",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text(
              "Kelola data akademik mahasiswa poliban.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ===== BUTTON TAMBAH =====
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahMahasiswaPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    "+ Tambah Mahasiswa",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ===== SEARCH =====
            TextField(
              decoration: InputDecoration(
                hintText: "Cari NIM atau Nama...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ===== FILTER =====
            Row(
              children: [
                _filterBox("PRODI", "Semua"),
                const SizedBox(width: 10),
                _filterBox("SEMESTER", "Semua"),
              ],
            ),

            const SizedBox(height: 20),

            // 🔥 DATA DINAMIS MAHASISWA
            Column(
              children: mahasiswa.map((item) {
                return StudentCard(
                  nim: item.nim,
                  nama: item.nama,
                  jurusan: item.jurusan,
                  semester: item.semester,
                  status: item.status,

                  onDetail: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>  DetailMahasiswaPage(mahasiswa: item),
                      ),
                    );
                  },

                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditMahasiswaPage(mahasiswa: item),
                      ),
                    );
                  },

                  onDelete: () {
                    // 🔥 MUNCULKAN POP-UP KONFIRMASI HAPUS
                    _showDeleteConfirmation(context, item);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
            
            const Center(
              child: Text(
                "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FILTER =================
  Widget _filterBox(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontSize: 13)),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}