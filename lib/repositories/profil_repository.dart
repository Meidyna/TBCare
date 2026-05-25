import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_constants.dart';
import '../core/session/user_session.dart';
import '../services/api_services.dart';

class ProfilRepository {
  static Future<void> getProfile() async {
    final res = await ApiService.get(ApiConstants.getProfile);
    final data = res['data'];
    final prefs = await SharedPreferences.getInstance();
    final fotoPath = prefs.getString('foto_profil_${UserSession.email}') ?? '';

    UserSession.simpan(
      nama: data['nama_lengkap'] ?? '',
      email: data['email'] ?? '',
      telepon: data['no_telepon'] ?? '',
      token: UserSession.token,
      fotoPath: fotoPath,
    );
  }

  static Future<void> updateProfile({
    required String nama,
    required String email,
    required String telepon,
  }) async {
    final res = await ApiService.put(ApiConstants.updateProfile, {
      "nama_lengkap": nama,
      "email": email,
      "no_telepon": telepon,
    });
    final data = res['data'];
    UserSession.simpan(
      nama: data['nama_lengkap'] ?? '',
      email: data['email'] ?? '',
      telepon: data['no_telepon'] ?? '',
      token: UserSession.token,
    );
  }
}