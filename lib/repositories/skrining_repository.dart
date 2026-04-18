import '../core/constants/api_constants.dart';
import '../models/skrining_model.dart';
import '../services/api_services.dart';

class SkriningRepository {
  // Ambil semua pertanyaan dari API
  static Future<List<PertanyaanModel>> getPertanyaan() async {
    final res = await ApiService.get(ApiConstants.getPertanyaanSkrining);
    final List data = res['data'];
    return data.map((e) => PertanyaanModel.fromJson(e)).toList();
  }

  // Kirim jawaban ke API
  static Future<HasilSkriningModel> postJawaban(Map<String, String> jawaban) async {
    // Ubah dari Map menjadi format yang diminta API
    final List<Map<String, String>> jawabanList = jawaban.entries.map((e) => {
      "id_pertanyaan": e.key,
      "jawaban": e.value,
    }).toList();

    final res = await ApiService.post(ApiConstants.postJawabanSkrining, {
      "jawaban": jawabanList,
    });

    return HasilSkriningModel.fromJson(res['data']);
  }
}