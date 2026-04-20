import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/session/user_session.dart';
import '../../repositories/obat_repository.dart';
import '../../models/obat_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasNotification = true;

  // ← Data jadwal dari API
  ObatModel? _obatBerikutnya;
  bool _isLoadingJadwal = false;

  String get _userName => UserSession.nama;

  @override
  void initState() {
    super.initState();
    _loadJadwal();
  }

  Future<void> _loadJadwal() async {
    setState(() => _isLoadingJadwal = true);
    try {
      final jadwal = await ObatRepository.getJadwalHariIni();
      setState(() {
        // Ambil obat pertama yang belum diminum
        _obatBerikutnya = jadwal.obatBerikutnya.isNotEmpty
            ? jadwal.obatBerikutnya.first
            : null;
      });
    } catch (e) {
      setState(() => _obatBerikutnya = null);
    } finally {
      setState(() => _isLoadingJadwal = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(screenWidth, _userName),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickMenu(),
                    const SizedBox(height: 20),
                    _buildTipsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.buttonBackground,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.chatbot),
        child: Image.asset(
          "assets/icons/chatbot.png",
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  Widget _buildHeader(double width, String userName) {
    Widget buildNotificationIcon() {
      return Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifikasi),
          ),
          if (hasNotification)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        width * 0.06,
        width * 0.06,
        width * 0.06,
        width * 0.12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.buttonBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting + notifikasi ──────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang,",
                    style: TextStyle(color: Colors.white, fontSize: width * 0.05),
                  ),
                  Text(
                    userName.isEmpty ? 'User' : userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              buildNotificationIcon(),
            ],
          ),

          const SizedBox(height: 25),

          // ── Card jadwal berikutnya ─────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.mainBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.buttonBackground.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/icons/gelombang.png",
                          width: 24,
                          height: 24,
                          color: AppTheme.buttonBackground,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Jadwal Berikutnya",
                              style: TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                            const SizedBox(height: 4),

                            // ← Tampilkan data dari API
                            if (_isLoadingJadwal)
                              const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else if (_obatBerikutnya == null)
                              const Text(
                                "Belum ada jadwal minum obat",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _obatBerikutnya!.namaObat,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _obatBerikutnya!.waktuMinum.join(', '),
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol Lihat hanya muncul kalau ada obat
                if (_obatBerikutnya != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.jadwal),
                    child: const Text(
                      "Lihat",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Menu Cepat",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _quickButton(
              "assets/icons/stethoscope.png",
              "Skrining Mandiri",
              AppTheme.buttonBackground,
                  () => Navigator.pushNamed(context, AppRoutes.skrining),
            ),
            _quickButton(
              "assets/icons/calendar.png",
              "Jadwal \n Obat",
              const Color(0xFFFF7800),
                  () => Navigator.pushNamed(context, AppRoutes.jadwal),
            ),
            _quickButton(
              "assets/icons/location.png",
              "Layanan Kesehatan",
              AppTheme.buttonBackground,
                  () => Navigator.pushNamed(context, AppRoutes.layananKesehatan),
            ),
            _quickButton(
              "assets/icons/book.png",
              "Konten Edukasi",
              const Color(0xFFFF7800),
                  () => Navigator.pushNamed(context, AppRoutes.kontenEdukasi),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickButton(
      String assetPath,
      String label,
      Color bgColor,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              assetPath,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7800).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: Color(0xFFFF7800)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tips Hari Ini",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Pastikan untuk minum obat TBC Anda pada waktu yang sama setiap hari.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}