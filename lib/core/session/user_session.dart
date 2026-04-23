import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  UserSession._();

  static String _nama = '';
  static String _email = '';
  static String _telepon = '';
  static String _token = '';
  static String _fotoPath = '';

  static String get nama => _nama.isEmpty ? 'User' : _nama;
  static String get email => _email;
  static String get telepon => _telepon;
  static String get token => _token;
  static String get fotoPath => _fotoPath;

  static void simpan({
    required String nama,
    required String email,
    required String telepon,
    required String token,
    String fotoPath = '',
  }) {
    _nama = nama;
    _email = email;
    _telepon = telepon;
    _token = token;
    _fotoPath = fotoPath;
  }

  // ← Simpan token ke SharedPreferences
  static Future<void> simpanToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // ← Load token dari SharedPreferences
  static Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static void hapus() {
    _nama = '';
    _email = '';
    _telepon = '';
    _token = '';
    _fotoPath = '';
  }

  // ← Hapus token dari SharedPreferences
  static Future<void> hapusToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}