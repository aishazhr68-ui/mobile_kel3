import 'package:flutter/material.dart';

class StudentNilaiCard extends StatelessWidget {
  final String nim;
  final String nama;
  final String nilai;
  final String grade;
  final Color warna;
  final VoidCallback onTap;

  const StudentNilaiCard({
    super.key,
    required this.nim,
    required this.nama,
    required this.nilai,
    required this.grade,
    required this.warna,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  nim,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Nilai Akhir: $nilai",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 30,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: warna.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Text(
              grade,
              style: TextStyle(
                color: warna,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),

          const SizedBox(width: 12),

          InkWell(
            onTap: onTap,
            child: const Icon(
              Icons.remove_red_eye_outlined,
              color: Color(0xFF2563EB),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}