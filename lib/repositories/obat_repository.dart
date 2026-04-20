import '../core/constants/api_constants.dart';
import '../models/obat_model.dart';
import '../services/api_services.dart';

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
    return ObatModel.fromJson(res['data']);
  }

  // Hapus obat
  static Future<void> hapusObat(String idObat) async {
    final endpoint = ApiConstants.deleteObat.replaceAll(':id', idObat);
    await ApiService.delete(endpoint);
  }

  // Konfirmasi minum obat
  static Future<void> konfirmasiMinum(String idObat) async {
    final now = DateTime.now();
    final tanggal =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await ApiService.post(ApiConstants.konfirmasiObat, {
      "id_obat": idObat,
      "tanggal": tanggal,
    });
  }
}