import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/mahasiswa/khs_model.dart';
import 'package:flutter_application_1/services/mahasiswa/khs_service.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';

class KhsMhsPage extends StatefulWidget {
  const KhsMhsPage({super.key});

  @override
  State<KhsMhsPage> createState() => _KhsMhsPageState();
}

class _KhsMhsPageState extends State<KhsMhsPage> {
  bool isLoading = true;
  late KhsInfoModel infoKhs;
  List<KhsMatkulModel> daftarMatkul = [];
  final KhsService _service = KhsService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final info = await _service.getInfoKhs();
      final matkul = await _service.getDaftarKhs();
      if (!mounted) return;
      setState(() {
        infoKhs = info;
        daftarMatkul = matkul;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      debugPrint("Error loading KHS: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const CustomBottomNavMahasiswa(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 120,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E40AF)),
          label: const Text(
            "Kembali", 
            style: TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.w600)
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const Text(
            "Kartu Hasil Studi", 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))
          ),
          const SizedBox(height: 4),
          const Text(
            "KHS Mahasiswa", 
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14)
          ),
          
          const SizedBox(height: 24),
          
          // Card Profil
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(16), 
              border: Border.all(color: const Color(0xFFE2E8F0))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54, 
                      height: 54, 
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9), 
                        borderRadius: BorderRadius.circular(12)
                      ), 
                      child: const Icon(Icons.person_outline, size: 28, color: Color(0xFF64748B))
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            infoKhs.nama, 
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1E293B))
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "NIM: ${infoKhs.nim}", 
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(child: _buildInfoItem("PROGRAM STUDI", infoKhs.prodi)),
                    Expanded(child: _buildInfoItem("KELAS", infoKhs.kelas)),
                  ],
                ),
                
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("DOSEN PEMBIMBING", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(infoKhs.dosenWali, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        infoKhs.status, 
                        style: const TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Text(
            "Daftar Matakuliah", 
            style: TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.w800)
          ),
          const SizedBox(height: 12),
          
          // List Matakuliah
          ...daftarMatkul.map((matkul) => _buildKhsMatkulCard(matkul)),
          
          const SizedBox(height: 20),
          
          // Grid Bottom (Total SKS & IP)
          Row(
            children: [
              // Total SKS Box (Blue)
              Expanded(
                flex: 1,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0052CC), 
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu_book, color: Colors.white, size: 28),
                      const SizedBox(height: 12),
                      const Text("TOTAL SKS", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Text(
                        "${daftarMatkul.fold(0, (sum, m) => sum + m.sks)}", 
                        style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // IP Boxes
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildBottomIpBox("IPS", infoKhs.ipSemester.toString(), Icons.trending_up, const Color(0xFFD1FAE5), const Color(0xFF10B981)),
                    const SizedBox(height: 12),
                    _buildBottomIpBox("IPK", infoKhs.ipKumulatif.toString(), Icons.stars, const Color(0xFFDBEAFE), const Color(0xFF3B82F6)),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          const Center(
            child: Text(
              "© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildKhsMatkulCard(KhsMatkulModel data) {
    // Penentuan warna badge huruf (Abu-abu untuk AB/B/C, Biru untuk A)
    final bool isExcellent = data.nilaiHuruf == "A";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.nama, 
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E293B))
                ),
                const SizedBox(height: 6),
                Text(
                  "${data.kode}  •  ${data.sks} SKS", 
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)
                ),
              ],
            ),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Nilai", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(
                    data.nilaiAngka, 
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0052CC))
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isExcellent ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    data.nilaiHuruf,
                    style: TextStyle(
                      color: isExcellent ? Colors.white : const Color(0xFF475569),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomIpBox(String label, String value, IconData icon, Color iconBgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.w900)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 14),
          ),
        ],
      ),
    );
  }
}