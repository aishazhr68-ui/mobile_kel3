import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/mahasiswa/custom_bottom_navmahasiswa.dart';

class PresensiMahasiswaPage extends StatefulWidget {
  // 1. TAMBAHAN BARU: Variabel untuk menerima data dinamis dari Dashboard
  final String namaMatkul;
  final String sesi;
  final String waktu;
  final String kelas;

  const PresensiMahasiswaPage({
    super.key,
    required this.namaMatkul,
    required this.sesi,
    required this.waktu,
    this.kelas = "TI-4C", // Default value
  });

  @override
  State<PresensiMahasiswaPage> createState() => _PresensiMahasiswaPageState();
}

class _PresensiMahasiswaPageState extends State<PresensiMahasiswaPage> {
  String selectedStatus = "Hadir";
  bool isSubmitting = false;

  // 2. TAMBAHAN BARU: Fungsi untuk memunculkan Popup/Dialog Presensi Berhasil
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup dengan asal tap di luar
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Presensi Berhasil!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                Text(
                  "Status kehadiran Anda untuk sesi\n${widget.namaMatkul} telah berhasil\ndirekam.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.4),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("STATUS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                          Text(selectedStatus, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("WAKTU", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                          Text(widget.waktu, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pop(context); // Kembali ke dashboard
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B53BF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text("Selesai", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitPresensi() {
    setState(() => isSubmitting = true);
    // Simulasi proses loading (misal: kirim data ke API)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => isSubmitting = false);
      _showSuccessDialog(); // Tampilkan popup setelah loading selesai
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D47A1), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text("Kembali", style: TextStyle(color: Color(0xFF0D47A1), fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: const CustomBottomNavMahasiswa(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CARD DETAIL JADWAL BIRU ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0B47A1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned(
                      right: -15, top: -15,
                      child: Stack(
                        children: [
                          Icon(Icons.keyboard_arrow_down, size: 130, color: Colors.white.withOpacity(0.08)),
                          Positioned(top: -35, child: Icon(Icons.keyboard_arrow_down, size: 130, color: Colors.white.withOpacity(0.08))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: Text(widget.kelas, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: Text(widget.sesi, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.namaMatkul, // 3. PANGGIL DATA DINAMIS DI SINI
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text("Rabu, 13 Mei 2024", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // --- CARD INPUT KEHADIRAN ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  const Text("Input Kehadiran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                  const SizedBox(height: 6),
                  const Text("Silakan pilih status kehadiran Anda\nuntuk sesi ini.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.4)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildStatusCard(icon: Icons.check, title: "Hadir", baseColor: const Color(0xFF0B53BF), isSelected: selectedStatus == "Hadir", onTap: () => setState(() => selectedStatus = "Hadir"))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatusCard(icon: Icons.description, title: "Izin", baseColor: const Color(0xFFF59E0B), isSelected: selectedStatus == "Izin", onTap: () => setState(() => selectedStatus = "Izin"))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildStatusCard(icon: Icons.medical_services, title: "Sakit", baseColor: const Color(0xFF64748B), isSelected: selectedStatus == "Sakit", onTap: () => setState(() => selectedStatus = "Sakit"))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatusCard(icon: Icons.close, title: "Alfa", baseColor: const Color(0xFFDC2626), isSelected: selectedStatus == "Alfa", onTap: () => setState(() => selectedStatus = "Alfa"))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Batas waktu input: 12:45", style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- TOMBOL SIMPAN ---
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: isSubmitting ? null : _submitPresensi, // Panggil fungsi di sini
                  icon: isSubmitting 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                      : const Icon(Icons.save, color: Colors.white, size: 20),
                  label: Text(isSubmitting ? "Menyimpan..." : "Simpan", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B53BF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 24), elevation: 0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- CARD REKAP ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                  decoration: BoxDecoration(color: const Color(0xFFEDF4FC), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFD0E1FD), width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("REKAP KEHADIRAN", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF5A6A85), letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          RichText(text: const TextSpan(style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), children: [TextSpan(text: "14/16 ", style: TextStyle(color: Color(0xFF1D4ED8))), TextSpan(text: "Sesi", style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500))])),
                        ],
                      ),
                      Container(width: 58, height: 58, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF0B53BF), width: 4.5)), child: const Center(child: Text("75%", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF1E293B))))),
                    ],
                  ),
                ),
                const Positioned(bottom: 6, child: Text("© 2026 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4, fontWeight: FontWeight.w400))),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({required IconData icon, required String title, required Color baseColor, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(color: baseColor.withOpacity(0.12), borderRadius: BorderRadius.circular(14), border: Border.all(color: isSelected ? baseColor : baseColor.withOpacity(0.4), width: isSelected ? 2 : 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 24)),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: baseColor, fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}