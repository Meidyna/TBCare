import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════
// PENGATURAN PAGE
// ════════════════════════════════════════════════════════════════
class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {

  bool _pengingat = true;
  bool _suara     = true;

  // ════════════════════════════════════════════════════════════
  // FUNGSI
  // ════════════════════════════════════════════════════════════

  void _ubahPengingat(bool nilai) {
    setState(() => _pengingat = nilai);
    // TODO: await ApiService.updatePengaturan(pengingatObat: nilai);
  }

  void _ubahSuara(bool nilai) {
    setState(() => _suara = nilai);
    // TODO: await ApiService.updatePengaturan(suaraNotifikasi: nilai);
  }

  void _ubahKataSandi() {
    Navigator.pushNamed(context, AppRoutes.ubahKataSandi);
  }

  void _tentangAplikasi() {
    Navigator.pushNamed(context, AppRoutes.tentangAplikasi);
  }

  void _panduanPengguna() {
    Navigator.pushNamed(context, AppRoutes.panduanPengguna);
  }

  // ════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 80.0;
    final double headerTotal = topPadding + headerContentHeight;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: Column(
        children: [

          _buildHeader(width, headerTotal, topPadding),

          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, 24, width * 0.05, 32),
              children: [

                // ── Notifikasi ────────────────────────────────
                _sectionLabel('NOTIFIKASI'),
                const SizedBox(height: 8),
                // ✅ Card notifikasi dengan border + shadow tebal
                _buildCard(
                  child: Column(
                    children: [
                      _buildToggleItem(
                        icon: Icons.notifications_outlined,
                        label: 'Pengingat Obat',
                        sublabel: 'Notifikasi jadwal minum obat',
                        nilai: _pengingat,
                        onChanged: _ubahPengingat,
                        showDivider: true, // ✅ garis pemisah di tengah
                      ),
                      _buildToggleItem(
                        icon: Icons.volume_up_outlined,
                        label: 'Suara Notifikasi',
                        sublabel: 'Aktifkan suara alarm',
                        nilai: _suara,
                        onChanged: _ubahSuara,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Privasi & Keamanan ────────────────────────
                _sectionLabel('Privasi & Keamanan'),
                const SizedBox(height: 8),
                _buildCard(
                  child: _buildMenuItem(
                    icon: Icons.lock_outline_rounded,
                    label: 'Ubah Kata Sandi',
                    onTap: _ubahKataSandi,
                    showDivider: false,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Tentang — ✅ dipisah menjadi 2 card sendiri
                _sectionLabel('Tentang'),
                const SizedBox(height: 8),

                // Card Tentang Aplikasi
                _buildCard(
                  child: _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'Tentang Aplikasi',
                    onTap: _tentangAplikasi,
                    showDivider: false,
                  ),
                ),

                const SizedBox(height: 10),

                // Card Panduan Pengguna
                _buildCard(
                  child: _buildMenuItem(
                    icon: Icons.menu_book_outlined,
                    label: 'Panduan Pengguna',
                    onTap: _panduanPengguna,
                    showDivider: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // WIDGET BUILDERS
  // ════════════════════════════════════════════════════════════

  Widget _buildHeader(double width, double headerTotal, double topPadding) {
    return Container(
      height: headerTotal,
      width: width,
      padding: EdgeInsets.only(
        top: topPadding + 10,
        left: 4,
        right: width * 0.05,
        bottom: 12,
      ),
      decoration: const BoxDecoration(color: AppTheme.buttonBackground),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: width * 0.02),
          Text(
            'Pengaturan',
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String teks) {
    return Text(
      teks,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
        letterSpacing: 0.5,
      ),
    );
  }

  /// ✅ Wrapper card dengan border tepi + shadow tebal
  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),  // ✅ garis tepi
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10), // ✅ shadow lebih tebal
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Baris toggle switch
  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required String sublabel,
    required bool nilai,
    required ValueChanged<bool> onChanged,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade500, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sublabel,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Switch(
                value: nilai,
                onChanged: onChanged,
                activeColor: AppTheme.buttonBackground,
              ),
            ],
          ),
        ),
        // ✅ Garis pemisah antar item toggle
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey.shade500,
          ),
      ],
    );
  }

  /// Baris menu dengan ikon + label + panah
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey.shade200,
          ),
      ],
    );
  }
}