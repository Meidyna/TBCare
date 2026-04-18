import '../core/constants/api_constants.dart';
import '../models/layanan_kesehatan_model.dart';
import '../services/api_services.dart';

class LayananRepository {
  static Future<List<LayananKesehatanModel>> getLayanan({int page = 1}) async {
    final res = await ApiService.get(
      '${ApiConstants.layananKesehatan}?page=$page&limit=20', // ← tambah limit=20
    );
    final List data = res['data']['healthServices'];
    return data.map((e) => LayananKesehatanModel.fromJson(e)).toList();
  }
}