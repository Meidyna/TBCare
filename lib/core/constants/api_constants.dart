class ApiConstants {
  static const String baseUrl = "http://34.101.96.107:3000";

  // ================= AUTH & USER =================
  static const String login = "/api/auth/login";
  static const String register = "/api/auth/register";
  static const String forgotPassword = "/api/auth/forgot-password";

  static const String getProfile = "/api/users/profile";
  static const String updateProfile = "/api/users/profile";
  static const String changePassword = "/api/users/change-password";

  // ================= EDUKASI =================
  static const String getEducation = "/api/konten";
  static const String getDetailEducation = "/api/konten/:id";
  static const String getFilterlEducation = "/api/konten?tipe=artikel";

  // ================= MEDICINE =================
  static const String postObat = "/api/obat";
  static const String detailObat = "/api/obat/:id";
  static const String updateObat = "/api/obat/:id";
  static const String deleteObat = "/api/obat/:id";
  static const String getJadwal = "/api/jadwal/hari-ini";
  static const String konfirmasiObat = "/api/riwayat-obat";
  static const String riwayatObat = "/api/riwayat-obat";

  // ================= SKRINING =================
  static const String getPertanyaanSkrining = "/api/skrining/pertanyaan";
  static const String postJawabanSkrining = "/api/skrining";
  static const String hasilSkrining = "/api/skrining/:id";

  // ================= CHATBOT =================
  static const String chatbot = "/api/chatbot";
  static const String historyChatbot = "/api/chatbot/history";
  static const String historyChatbotSession = "/api/chatbot/history/:sessionId";
  static const String deleteHistoryChatbotSession = "/api/chatbot/history/:sessionId";
  static const String postChatbot = "https://n8n.pika.unila.ac.id/webhook/tbcare-chat";

  // ================= LAYANAN KESEHATAN =================
  static const String layananKesehatan = "/api/layanan-kesehatan";

  // ================= NOTIFIKASI =================
  static const String getNotifikasi = "/api/notifikasi";
}

