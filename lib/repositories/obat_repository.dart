import '../core/constants/api_constants.dart';
import '../models/obat_model.dart';
import '../services/api_services.dart';
import '../services/notification_service.dart';

class ObatRepository {
  // Ambil jadwal hari ini
  static Future<JadwalHariIniModel> getJadwalHariIni() async {
    final res = await ApiService.get(ApiConstants.getJadwal);
    return JadwalHariIniModel.fromJson(res['data']);
  }

  // Tambah obat baru
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

  // Hapus obat
  static Future<void> hapusObat(String idObat, List<String> waktuMinum) async {
    final endpoint = ApiConstants.deleteObat.replaceAll(':id', idObat);
    await ApiService.delete(endpoint);

    try {
      // ← Batalkan notifikasi
      await NotificationService.batalkanNotifikasiObat(
        obatId: idObat,
        waktuMinum: waktuMinum,
      );
    } catch (e) {
      // ← Abaikan error pembatalan notifikasi
      // Error ini dari Android saat format notifikasi tidak cocok
    }
  }

  // Konfirmasi minum obat
  static Future<void> konfirmasiMinum(String idObat, String namaObat) async {
    final now = DateTime.now();
    final tanggal =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    await ApiService.post(ApiConstants.konfirmasiObat, {
      "id_obat": idObat,
      "tanggal": tanggal,
    });

    // ← Tampilkan notifikasi konfirmasi
    await NotificationService.tampilkanNotifikasiDiminum(namaObat);
  }
}