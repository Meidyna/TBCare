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

  /// Nama user yang sedang login
  static String get nama => _nama.isEmpty ? 'User' : _nama;

  /// Dipanggil saat login berhasil
  static void simpan({required String nama}) {
    _nama = nama;
  }

  /// Dipanggil saat logout
  static void hapus() {
    _nama = '';
  }
}