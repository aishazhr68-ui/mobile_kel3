import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String nim;
  final String nama;
  final String jurusan;
  final String semester;
  final String status;

  final VoidCallback onDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentCard({
    super.key,
    required this.nim,
    required this.nama,
    required this.jurusan,
    required this.semester,
    required this.status,
    required this.onDetail,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              Text(
                nim,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: status == "AKTIF"
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == "AKTIF"
                        ? Colors.green
                        : Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            nama,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Divider(
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.school_outlined,
                size: 18,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 6),
              Text(jurusan),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 6),
              Text(semester),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              _actionBtn(
                Icons.visibility,
                Colors.blue,
                onDetail,
              ),

              const SizedBox(width: 8),

              _actionBtn(
                Icons.edit,
                Colors.grey,
                onEdit,
              ),

              const SizedBox(width: 8),

              _actionBtn(
                Icons.delete,
                Colors.red,
                onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: color,
          size: 18,
        ),
      ),
    );
  }
}