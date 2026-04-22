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

  static void hapus() {
    _nama = '';
    _email = '';
    _telepon = '';
    _token = '';
    _fotoPath = '';
  }
}