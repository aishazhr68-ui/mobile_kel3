class UserModel {
  final int id;
  final String nama;
  final String email;
  final String role;
  final String token;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
    );
  }
} 