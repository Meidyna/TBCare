import '../core/constants/api_constants.dart';
import '../models/layanan_kesehatan_model.dart';
import '../services/api_services.dart';

class LayananRepository {
  static List<LayananKesehatanModel> _cache = [];
  static bool _allLoaded = false;

  static Future<List<LayananKesehatanModel>> getLayanan({int page = 1}) async {
    final res = await ApiService.get(
      '${ApiConstants.layananKesehatan}?page=$page&limit=20',
    );
    final List data = res['data']['healthServices'];
    return data.map((e) => LayananKesehatanModel.fromJson(e)).toList();
  }

  static Future<List<LayananKesehatanModel>> getAllLayanan() async {
    if (_allLoaded && _cache.isNotEmpty) return _cache;

    List<LayananKesehatanModel> semua = [];
    int page = 1;

    while (true) {
      final data = await getLayanan(page: page);
      semua.addAll(data);
      if (data.length < 20) break;
      page++;
    }

    _cache = semua;
    _allLoaded = true;
    return semua;
  }

  static void clearCache() {
    _cache = [];
    _allLoaded = false;
  }
}