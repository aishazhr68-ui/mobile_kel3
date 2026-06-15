import '../../models/admin/profil_model.dart';

class ProfileService {
  Future<ProfileModel> getProfile() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return ProfileModel(
      nama: "Admin Poliban",
      jabatan: "Administrator Akademik",
      inisial: "AD",
    );
  }
}