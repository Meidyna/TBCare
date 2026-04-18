import '../services/api_services.dart';

class ChatbotRepository {
  static Future<String> kirimPesan(String pesan) async {
    final res = await ApiService.kirimPesanChatbot(pesan);

    return res; // ✅ karena sudah String
  }
}
