import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../core/session/user_session.dart';
import '../models/obat_model.dart';
import '../services/api_services.dart';
import '../services/notification_service.dart';

class ObatRepository {
  // ─── History Obat (per akun) ───────────────────────────────────────────────

  static String _historyKey(String userId) => 'history_obat_$userId';

  // Ambil userId dari SharedPreferences (disimpan saat login)
  static Future<String> _getUserId() async {
    final email = UserSession.email;
    return email.isNotEmpty ? email : 'guest';
  }

  static Future<List<Map<String, String>>> getHistoryObat() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await _getUserId();
    final raw = prefs.getString(_historyKey(userId));
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.map((e) => Map<String, String>.from(e)).toList();
  }

  static Future<void> _simpanKeHistory(String namaObat, String dosis) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await _getUserId();
    final history = await getHistoryObat();

    // Cek apakah sudah ada (case-insensitive), kalau ada update dosisnya
    final index = history.indexWhere(
          (e) => e['nama']!.toLowerCase() == namaObat.toLowerCase(),
    );

    if (index >= 0) {
      history[index] = {'nama': namaObat, 'dosis': dosis};
    } else {
      history.insert(0, {'nama': namaObat, 'dosis': dosis}); // terbaru di atas
    }

    // Maksimal simpan 20 history
    final trimmed = history.take(20).toList();
    await prefs.setString(_historyKey(userId), jsonEncode(trimmed));
  }

  // ─── Existing Methods ──────────────────────────────────────────────────────

  static Future<JadwalHariIniModel> getJadwalHariIni() async {
    final res = await ApiService.get(ApiConstants.getJadwal);
    return JadwalHariIniModel.fromJson(res['data']);
  }

  static Future<ObatModel> tambahObat({
    required String namaObat,
    required String dosis,
    required List<String> waktuMinum,
  }) async {
    final res = await ApiService.post(ApiConstants.postObat, {
      "nama_obat": namaObat,
      "dosis": dosis,
      "waktu_minum": waktuMinum,
    });

    final obat = ObatModel.fromJson(res['data']);

    // Simpan ke history lokal per akun
    await _simpanKeHistory(namaObat, dosis);

    for (final waktu in waktuMinum) {
      await NotificationService.jadwalkanNotifikasiObat(
        obatId: obat.id,
        namaObat: namaObat,
        dosis: dosis,
        waktuMinum: waktu,
      );
      await NotificationService.catatJadwalKeHistory(
        obatId: obat.id,
        namaObat: namaObat,
        dosis: dosis,
        waktuMinum: waktu,
      );
    }

    return obat;
  }

  static Future<void> hapusObat(String idObat, List<String> waktuMinum) async {
    final endpoint = ApiConstants.deleteObat.replaceAll(':id', idObat);
    await ApiService.delete(endpoint);

    try {
      await NotificationService.batalkanNotifikasiObat(
        obatId: idObat,
        waktuMinum: waktuMinum,
      );
    } catch (e) {
      // Abaikan error pembatalan notifikasi
    }
  }

  static Future<void> konfirmasiMinum(String idObat, String namaObat) async {
    final now = DateTime.now();
    final tanggal =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    await ApiService.post(ApiConstants.konfirmasiObat, {
      "id_obat": idObat,
      "tanggal": tanggal,
    });

    await NotificationService.tampilkanNotifikasiDiminum(namaObat);
  }
}