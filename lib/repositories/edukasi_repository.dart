import '../core/constants/api_constants.dart';
import '../features/edukasi/konten_edukasi_page.dart';
import '../services/api_services.dart';

class EdukasiRepository {
  static Future<List<KontenEdukasiModel>> getKonten() async {
    final res = await ApiService.get(ApiConstants.getEducation);
    final List data = res['data'];
    return data.map((e) => KontenEdukasiModel.fromJson(e)).toList();
  }

  static Future<List<KontenEdukasiModel>> getKontenByTipe(String tipe) async {
    final res = await ApiService.get('${ApiConstants.getEducation}?tipe=$tipe');
    final List data = res['data'];
    return data.map((e) => KontenEdukasiModel.fromJson(e)).toList();
  }
}