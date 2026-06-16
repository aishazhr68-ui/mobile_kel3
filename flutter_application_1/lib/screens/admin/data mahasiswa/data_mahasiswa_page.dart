import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/models/admin/mahasiswa_model.dart';
import 'package:flutter_application_1/widgets/admin/custom_bottom_nav.dart';
import 'package:flutter_application_1/widgets/admin/student_card.dart';
import '../../../services/admin/mahasiswa_service.dart';
import 'tambah_mahasiswa_page.dart';
import 'detail_mahasiswa_page.dart';
import 'edit_mahasiswa_page.dart';

class DataMahasiswaPage extends StatefulWidget {
  const DataMahasiswaPage({super.key});

  @override
  State<DataMahasiswaPage> createState() => _DataMahasiswaPageState();
}

class _DataMahasiswaPageState extends State<DataMahasiswaPage> {
  bool isLoading = true;
  bool isLoadMore = false;
  int currentPage = 1;
  String errorMessage = "";
  List<MahasiswaModel> mahasiswa = [];
  final MahasiswaService mahasiswaService = MahasiswaService();
  List<MahasiswaModel> filteredMahasiswa = []; // List yang akan ditampilkan
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ================= FUNGSI LOAD DATA (PAGINATION) =================
Future<void> loadData({bool isLoadMoreAction = false}) async {
    if (isLoadMoreAction) {
      setState(() => isLoadMore = true);
    } else {
      setState(() {
        isLoading = true;
        errorMessage = "";
        currentPage = 1;
      });
    }

    try {
      final pageToLoad = isLoadMoreAction ? currentPage + 1 : 1;
      // Memanggil service dengan parameter page
      final data = await mahasiswaService.getMahasiswa(page: pageToLoad);

      if (mounted) {
        setState(() {
          if (isLoadMoreAction) {
            mahasiswa.addAll(data); // Append data baru ke list lama
            currentPage++;          // Increment halaman
          } else {
            mahasiswa = data;       // Reset untuk load awal/refresh
          }
          filteredMahasiswa = mahasiswa;
          isLoading = false;
          isLoadMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isLoadMore = false;
          errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  void _runFilter(String enteredKeyword) {
  List<MahasiswaModel> results = [];
  if (enteredKeyword.isEmpty) {
    results = mahasiswa;
  } else {
    results = mahasiswa.where((mhs) =>
        mhs.nama.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
        mhs.nim.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
  }

  setState(() {
    filteredMahasiswa = results;
  });
}

  // ================= FUNGSI PROSES HAPUS (API) =================
  Future<void> _prosesHapusMahasiswa(BuildContext context, String nim) async {
    Navigator.pop(context); 

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sedang menghapus data..."), duration: Duration(seconds: 1)),
    );

    try {
      await mahasiswaService.deleteMahasiswa(nim);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data mahasiswa berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
        loadData(); 
      }
    } catch (e) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Hapus Data Mahasiswa?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Apakah Anda yakin ingin menghapus data ${mhs.nama} (${mhs.nim})? Tindakan ini permanen.",
                  style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: () => _prosesHapusMahasiswa(context, mhs.nim),
                    child: const Text("Ya, Hapus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Batal", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFAB(),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadData,
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
                      Text("SIMPADU", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text("ADMIN DASHBOARD", style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  const CircleAvatar(radius: 18, child: Icon(Icons.person)),
                ],
              ),
              const SizedBox(height: 20),

              // ===== TITLE =====
              const Text("Data Mahasiswa", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("Kelola data akademik mahasiswa poliban.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // ===== BUTTON TAMBAH =====
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TambahMahasiswaPage()),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10)],
                  ),
                  child: const Center(
                    child: Text("+ Tambah Mahasiswa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ===== SEARCH =====
              TextField(
                controller: searchController,
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  hintText: "Cari NIM atau Nama...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
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

              // 🔥 PENGECEKAN ERROR TAMPILAN
              if (errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 40),
                      const SizedBox(height: 12),
                      const Text("Terjadi Kesalahan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      const SizedBox(height: 8),
                      Text(errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 13)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadData,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Coba Lagi", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                )
              // 🔥 JIKA DATA KOSONG
              else if (mahasiswa.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(Icons.folder_open, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text("Tidak ada data mahasiswa.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              // 🔥 JIKA DATA ADA
            else
  Column(
    children: [
      // 1. Daftar Mahasiswa
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredMahasiswa.length,
        itemBuilder: (context, index) {
          final item = filteredMahasiswa[index];
          return StudentCard(
            nim: item.nim,
            nama: item.nama,
            jurusan: item.prodi,
            semester: "N/A",
            status: item.status,
            onDetail: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailMahasiswaPage(
                    daftarMahasiswa: mahasiswa,
                    indexAwal: index, // Gunakan index langsung dari builder
                  ),
                ),
              );
            },
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditMahasiswaPage(mahasiswa: item)),
              );
            },
            onDelete: () {
              _showDeleteConfirmation(context, item);
            },
          );
        },
      ),

      const SizedBox(height: 16),

      // 2. Tombol Lainnya (Load More)
      Center(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              // 🔥 Panggil loadData dengan mode load more
            loadData(isLoadMoreAction: true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFDDE5FF), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Lainnya",
                    style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF2563EB), size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16), // Jarak sebelum footer
    ],
  ),

              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
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
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
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