import '../core/constants/api_constants.dart';
import '../core/session/user_session.dart';
import '../services/api_services.dart';

class ProfilRepository {
  // Ambil profil dari API
  static Future<void> getProfile() async {
    final res = await ApiService.get(ApiConstants.getProfile);
    final data = res['data'];
    UserSession.simpan(
      nama: data['nama_lengkap'] ?? '',
      email: data['email'] ?? '',
      telepon: data['no_telepon'] ?? '',
      token: UserSession.token, // pertahankan token yang sudah ada
    );
  }

  // Update profil ke API
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
    // Update UserSession dengan data terbaru dari API
    UserSession.simpan(
      nama: data['nama_lengkap'] ?? '',
      email: data['email'] ?? '',
      telepon: data['no_telepon'] ?? '',
      token: UserSession.token,
    );
  }
}