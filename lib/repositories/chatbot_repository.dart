import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../core/session/user_session.dart';
import '../services/api_services.dart';

class ChatbotRepository {
  // ── Key session per user ──────────────────────────────────────
  static String get _sessionKey => 'chatbot_session_${UserSession.email}';

  // ── Ambil atau buat session ID ────────────────────────────────
  static Future<String> getOrCreateSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(_sessionKey);
    if (sessionId == null) {
      sessionId = const Uuid().v4();
      await prefs.setString(_sessionKey, sessionId);
    }
    return sessionId;
  }

  // ── Ambil history chat dari API ───────────────────────────────
  static Future<List<Map<String, String>>> getHistory() async {
    final sessionId = await getOrCreateSessionId();
    final endpoint = ApiConstants.historyChatbotSession
        .replaceAll(':sessionId', sessionId);
    try {
      final res = await ApiService.get(endpoint);
      final List data = res['data'];
      return data.map<Map<String, String>>((e) => {
        'user': e['pesan_user'] ?? '',
        'bot': e['respon_bot'] ?? '',
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // ── Kirim pesan ke AI dan simpan ke backend ───────────────────
  static Future<String> kirimPesan(String pesan) async {
    final sessionId = await getOrCreateSessionId();

    // Step 1: Hit AI eksternal (n8n)
    final aiResponse = await http.post(
      Uri.parse(ApiConstants.postChatbot),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'session_id': sessionId,
        'message': pesan,
      }),
    );

    String responBot = 'Maaf, tidak ada respon dari server.';
    if (aiResponse.statusCode == 200) {
      final aiData = jsonDecode(aiResponse.body);
      // Sesuaikan key response dari n8n
      responBot = aiData['output'] ??
          aiData['response'] ??
          aiData['text'] ??
          aiData['message'] ??
          responBot;
    }

    // Step 2: Simpan ke backend
    try {
      await ApiService.post(ApiConstants.chatbot, {
        'session_id': sessionId,
        'pesan_user': pesan,
        'respon_bot': responBot,
      });
    } catch (e) {
      // Tetap lanjut meski gagal simpan
    }

    return responBot;
  }

  // ── Reset session (mulai percakapan baru) ─────────────────────
  static Future<void> resetSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString(_sessionKey);

    // ← Hapus history di backend jika ada session
    if (sessionId != null) {
      try {
        final endpoint = ApiConstants.deleteHistoryChatbotSession
            .replaceAll(':sessionId', sessionId);
        await ApiService.delete(endpoint);
      } catch (e) {
        // Tetap lanjut reset meski API gagal
      }
    }

    // ← Hapus session ID lokal
    await prefs.remove(_sessionKey);
  }
}