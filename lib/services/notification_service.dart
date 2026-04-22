import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../core/session/user_session.dart';

// ════════════════════════════════════════════════════════════════
// MODEL HISTORY NOTIFIKASI (disimpan ke SharedPreferences)
// ════════════════════════════════════════════════════════════════
class NotifikasiModel {
  final String id;
  final String judul;
  final String pesan;
  final DateTime waktu;
  bool sudahDibaca;

  NotifikasiModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.waktu,
    this.sudahDibaca = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'pesan': pesan,
    'waktu': waktu.toIso8601String(),
    'sudahDibaca': sudahDibaca,
  };

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) =>
      NotifikasiModel(
        id: json['id'],
        judul: json['judul'],
        pesan: json['pesan'],
        waktu: DateTime.parse(json['waktu']),
        sudahDibaca: json['sudahDibaca'] ?? false,
      );

  /// Format waktu relatif untuk ditampilkan di UI
  String get waktuRelatif {
    final selisih = DateTime.now().difference(waktu);
    if (selisih.inMinutes < 1) return 'Baru saja';
    if (selisih.inMinutes < 60) return '${selisih.inMinutes} menit yang lalu';
    if (selisih.inHours < 24) return '${selisih.inHours} jam yang lalu';
    if (selisih.inDays == 1) return 'Kemarin';
    return '${selisih.inDays} hari yang lalu';
  }
}

// ════════════════════════════════════════════════════════════════
// NOTIFICATION SERVICE
// ════════════════════════════════════════════════════════════════
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static String get _prefKey => 'history_notifikasi_${UserSession.email}';

  // ── Channel Android ──────────────────────────────────────────
  static const AndroidNotificationChannel _channelJadwal =
  AndroidNotificationChannel(
    'jadwal_obat_channel',
    'Jadwal Minum Obat',
    description: 'Pengingat waktu minum obat sesuai jadwal',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  static const AndroidNotificationChannel _channelKonfirmasi =
  AndroidNotificationChannel(
    'konfirmasi_obat_channel',
    'Konfirmasi Minum Obat',
    description: 'Notifikasi saat obat sudah ditandai diminum',
    importance: Importance.defaultImportance,
  );

  // ════════════════════════════════════════════════════════════
  // INIT — panggil di main() sebelum runApp
  // ════════════════════════════════════════════════════════════
  static Future<void> init() async {
    // Setup timezone (wajib untuk zonedSchedule)
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    // Buat channel di Android
    final androidPlugin =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channelJadwal);
    await androidPlugin?.createNotificationChannel(_channelKonfirmasi);

    // Minta izin notifikasi (Android 13+)
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  // ════════════════════════════════════════════════════════════
  // JADWALKAN NOTIFIKASI — dipanggil saat user tambah obat
  // Muncul setiap hari pada jam yang ditentukan
  // ════════════════════════════════════════════════════════════
  static Future<void> jadwalkanNotifikasiObat({
    required String obatId,
    required String namaObat,
    required String dosis,
    required String waktuMinum,
  }) async {
    // ← Cek apakah pengingat aktif
    final prefs = await SharedPreferences.getInstance();
    final pengingatAktif = prefs.getBool('pengingat_obat') ?? true;
    if (!pengingatAktif) return; // ← jangan jadwalkan kalau dimatikan

    final suaraAktif = prefs.getBool('suara_notifikasi') ?? true;

    final parts = waktuMinum.split(':');
    final jam = int.parse(parts[0]);
    final menit = int.parse(parts[1]);
    final notifId = _buatNotifId(obatId, waktuMinum);

    final sekarang = tz.TZDateTime.now(tz.local);
    var jadwalPertama = tz.TZDateTime(
      tz.local, sekarang.year, sekarang.month, sekarang.day, jam, menit,
    );
    if (jadwalPertama.isBefore(sekarang)) {
      jadwalPertama = jadwalPertama.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      notifId,
      '💊 Waktunya Minum Obat',
      '$namaObat $dosis — Jangan lupa minum obat sesuai jadwal',
      jadwalPertama,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelJadwal.id,
          _channelJadwal.name,
          channelDescription: _channelJadwal.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: suaraAktif,      // ← suara sesuai setting
          enableVibration: suaraAktif, // ← getar sesuai setting
          styleInformation: BigTextStyleInformation(
            '$namaObat $dosis — Jangan lupa minum obat sesuai jadwal',
          ),
        ),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ════════════════════════════════════════════════════════════
  // NOTIFIKASI LANGSUNG — dipanggil saat user tekan "Minum"
  // ════════════════════════════════════════════════════════════
  static Future<void> tampilkanNotifikasiDiminum(String namaObat) async {
    // ID unik berdasarkan timestamp agar tidak tabrakan
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    await _plugin.show(
      id,
      '✅ Obat Diminum',
      '$namaObat telah berhasil dicatat. Pertahankan!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'konfirmasi_obat_channel',
          'Konfirmasi Minum Obat',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    // Simpan ke history
    await _simpanKeHistory(NotifikasiModel(
      id: 'diminum_$id',
      judul: 'Obat Diminum',
      pesan: '$namaObat telah berhasil dicatat. Pertahankan!',
      waktu: DateTime.now(),
      sudahDibaca: false,
    ));
  }

  // ════════════════════════════════════════════════════════════
  // BATALKAN NOTIFIKASI — dipanggil saat obat dihapus
  // ════════════════════════════════════════════════════════════
  static Future<void> batalkanNotifikasiObat({
    required String obatId,
    required List<String> waktuMinum, // semua slot waktu obat terseut
  }) async {
    for (final waktu in waktuMinum) {
      final notifId = _buatNotifId(obatId, waktu);
      await _plugin.cancel(notifId);
    }
  }

  // Batalkan SEMUA notifikasi terjadwal
  static Future<void> batalkanSemuaNotifikasi() async {
    await _plugin.cancelAll();
  }

// Cek apakah suara aktif
  static Future<bool> isSuaraAktif() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('suara_notifikasi') ?? true;
  }

  // ════════════════════════════════════════════════════════════
  // HISTORY NOTIFIKASI — disimpan ke SharedPreferences
  // ════════════════════════════════════════════════════════════

  /// Simpan notifikasi baru ke history (maks 50 item)
  static Future<void> _simpanKeHistory(NotifikasiModel notif) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefKey) ?? [];

    // Tambahkan di depan (terbaru duluan)
    raw.insert(0, jsonEncode(notif.toJson()));

    // Batasi 50 item
    if (raw.length > 50) raw.removeRange(50, raw.length);

    await prefs.setStringList(_prefKey, raw);
  }

  /// Ambil semua history notifikasi
  static Future<List<NotifikasiModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefKey) ?? [];
    return raw
        .map((e) => NotifikasiModel.fromJson(jsonDecode(e)))
        .toList();
  }

  /// Tandai satu notifikasi sebagai sudah dibaca
  static Future<void> tandaiDibaca(String notifId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefKey) ?? [];

    final updated = raw.map((e) {
      final map = jsonDecode(e) as Map<String, dynamic>;
      if (map['id'] == notifId) map['sudahDibaca'] = true;
      return jsonEncode(map);
    }).toList();

    await prefs.setStringList(_prefKey, updated);
  }

  /// Tandai semua sebagai sudah dibaca
  static Future<void> tandaiSemuaDibaca() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefKey) ?? [];

    final updated = raw.map((e) {
      final map = jsonDecode(e) as Map<String, dynamic>;
      map['sudahDibaca'] = true;
      return jsonEncode(map);
    }).toList();

    await prefs.setStringList(_prefKey, updated);
  }

  /// Hapus satu notifikasi dari history
  static Future<void> hapusDariHistory(String notifId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefKey) ?? [];

    raw.removeWhere((e) {
      final map = jsonDecode(e) as Map<String, dynamic>;
      return map['id'] == notifId;
    });

    await prefs.setStringList(_prefKey, raw);
  }

  // Hapus semua history notifikasi user ini
  static Future<void> hapusSemuaHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }

  // ════════════════════════════════════════════════════════════
  // HELPER
  // ════════════════════════════════════════════════════════════

  /// Buat notification ID (int) dari obatId + waktu
  /// Contoh: obatId="abc123", waktu="20:00" → hash unik
  static int _buatNotifId(String obatId, String waktu) {
    final gabung = '$obatId-$waktu';
    return gabung.hashCode.abs() % 2147483647; // max int32
  }

  /// Panggil ini saat jadwalkan notif agar history juga tersimpan
  /// (opsional — history pengingat dicatat saat notif dijadwalkan)
  static Future<void> catatJadwalKeHistory({
    required String obatId,
    required String namaObat,
    required String dosis,
    required String waktuMinum,
  }) async {
    final id = _buatNotifId(obatId, waktuMinum);
    await _simpanKeHistory(NotifikasiModel(
      id: 'jadwal_$id',
      judul: 'Jadwal Ditambahkan',
      pesan: '$namaObat $dosis dijadwalkan setiap hari pukul $waktuMinum',
      waktu: DateTime.now(),
      sudahDibaca: false,
    ));
  }
}