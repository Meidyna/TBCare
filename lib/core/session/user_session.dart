class UserSession {
  UserSession._();

  static String _nama = '';
  static String _email = '';
  static String _telepon = '';
  static String _token = ''; // 🔥 tambah ini

  static String get nama => _nama.isEmpty ? 'User' : _nama;
  static String get email => _email;
  static String get telepon => _telepon;
  static String get token => _token; // 🔥 getter token

  static void simpan({
    required String nama,
    required String email,
    required String telepon,
    required String token, // 🔥 tambah parameter
  }) {
    _nama = nama;
    _email = email;
    _telepon = telepon;
    _token = token; // 🔥 simpan token
  }

  static void hapus() {
    _nama = '';
    _email = '';
    _telepon = '';
    _token = ''; // 🔥 reset token
  }
}