class ProfileModel {
  final String nama;
  final String jabatan;
  final String inisial;

  ProfileModel({
    required this.nama,
    required this.jabatan,
    required this.inisial,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      nama: json["nama"],
      jabatan: json["jabatan"],
      inisial: json["inisial"],
    );
  }
}