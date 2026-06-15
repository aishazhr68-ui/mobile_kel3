import 'package:flutter/material.dart';

class TambahMahasiswaPage extends StatefulWidget {
  const TambahMahasiswaPage({super.key});

  @override
  State<TambahMahasiswaPage> createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  String? selectedGender;
  Widget _dropdownGender() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        RichText(
        text: TextSpan(
          text: "Jenis Kelamin",
          style: const TextStyle(color: Colors.black),
          children: const [
            TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),

        const SizedBox(height: 5),

        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),

          child: DropdownButton<String>(
            value: selectedGender,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),

            hint: const Text(
              "Pilih Jenis Kelamin",
              style: TextStyle(color: Colors.grey),
            ),

            items: const [
              DropdownMenuItem(
                value: "Laki-laki",
                child: Text("Laki-laki"),
              ),
              DropdownMenuItem(
                value: "Perempuan",
                child: Text("Perempuan"),
              ),
            ],

            onChanged: (val) {
              setState(() {
                selectedGender = val;
              });
            },
          ),
        ),
      ],
    ),
  );
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
        icon: const Icon(
      Icons.arrow_back,
      color: Color(0xFF2563EB),
    ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        "Kembali",
        style: TextStyle(
          color: Color(0xFF2563EB),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    

    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        children: [

          const Text(
            "Tambah Mahasiswa",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

  const SizedBox(height: 10),

          const SizedBox(height: 10),

          const Text(
            "Lengkapi formulir di bawah ini untuk mendaftarkan mahasiswa baru ke dalam sistem akademik.",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          

          // ================= INFORMASI PRIBADI =================
          _sectionCard(
            title: "Informasi Pribadi",
            icon: Icons.person_outline,
            children: [
              _input("NIM *", "Masukkan NIM"),
              _input("Nama Lengkap *", "Masukkan Nama Lengkap"),
              _input("Email *", "contoh@gmail.com", icon: Icons.mail_outline),
              _input("No Hp *", "08xxxxxxxxxx", icon: Icons.phone_outlined),
              _dropdownGender(),
              ],
            ),
          const SizedBox(height: 20),

          // ================= DATA AKADEMIK =================
          _sectionCard(
            title: "Data Akademik",
            icon: Icons.school_outlined,
            children: [
              _dropdown("Jurusan *", "Pilih Jurusan"),
              _dropdown("Program Studi *", "Pilih Program Studi"),

              Row(
                children: [
                  Expanded(child: _dropdown("Kelas *", "Pilih Kelas")),
                  const SizedBox(width: 10),
                  Expanded(child: _dropdown("Semester *", "Pilih Semester")),
                ],
              ),

              _dropdown("Tahun Akademik *", "Pilih Tahun Akademik"),
            ],
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "© 2024 Politeknik Negeri Banjarmasin.\nSistem Informasi Akademik Terpadu.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),

          const SizedBox(height: 20),

       // ================= BUTTON =================
Row(
  children: [
    Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey,
          side: const BorderSide(color: Color(0xFFD1D5DB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Batal"),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, size: 16, color: Colors.white),
            SizedBox(width: 6),
            Text(
              "Simpan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),

const SizedBox(height: 20),
        ],
      ),
    ),
    );
  }
  // ================= COMPONENT =================

Widget _sectionCard({
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Container(
    padding: const EdgeInsets.all(16), // 🔥 lebih lega
    decoration: BoxDecoration(
      color: Colors.white, // 🔥 lebih putih (beda dari background)
      borderRadius: BorderRadius.circular(16), // 🔥 lebih smooth

      border: Border.all(
        color: const Color(0xFFE5E7EB), // 🔥 border soft
        width: 1,
      ),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04), // 🔥 shadow halus
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ===== TITLE =====
        Row(
          children: [
            Icon(icon, color: const Color(0xFF2563EB), size: 18),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12), // 🔥 lebih lega

        ...children,
      ],
    ),
  );
}

  Widget _input(String label, String hint, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
        text: TextSpan(
          text: label.replaceAll(" *", ""),
          style: const TextStyle(color: Colors.black),
          children: const [
            TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null
                  ? Icon(icon, size: 18, color: Colors.grey)
                  : null,
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        RichText(
        text: TextSpan(
          text: label.replaceAll(" *", ""),
          style: const TextStyle(color: Colors.black),
          children: const [
            TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButton(
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(
                hint,
                style: const TextStyle(color: Colors.grey),
              ),
              items: const [],
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }
}