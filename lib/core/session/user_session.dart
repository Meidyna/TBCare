// lib/core/session/user_session.dart
//
// Simpan data user yang perlu diakses lintas halaman.
// Diisi saat login berhasil, dibaca di halaman manapun.
//
// TODO: Saat API tersedia, isi dari response login
// (misal dari token JWT atau endpoint /me)

class UserSession {
  UserSession._(); // mencegah instantiasi

  static String _nama = '';
  static String _email = '';
  static String _telepon = '';

  /// Nama user yang sedang login
  static String get nama => _nama.isEmpty ? 'User' : _nama;
  static String get email => _email;
  static String get telepon => _telepon;

  /// Dipanggil saat login berhasil
  static void simpan({
    required String nama,
    required String email,
    required String telepon,
  }) {
    _nama = nama;
    _email = email;
    _telepon = telepon;
  }

  /// Dipanggil saat logout
  static void hapus() {
    _nama = '';
    _email = '';
    _telepon = '';
  }
}




