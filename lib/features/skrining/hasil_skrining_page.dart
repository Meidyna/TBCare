import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';

// ════════════════════════════════════════════════════════════════
// MODEL HASIL
// ════════════════════════════════════════════════════════════════
class HasilSkriningModel {
  final String tingkat;        // "tinggi" | "sedang" | "rendah"
  final String judul;
  final String deskripsi;
  final List<String> rekomendasi;
  final Color warnaBg;
  final Color warnaIkon;
  final IconData ikon;

  const HasilSkriningModel({
    required this.tingkat,
    required this.judul,
    required this.deskripsi,
    required this.rekomendasi,
    required this.warnaBg,
    required this.warnaIkon,
    required this.ikon,
  });
}

// ════════════════════════════════════════════════════════════════
// HASIL SKRINING PAGE
// ════════════════════════════════════════════════════════════════
class HasilSkriningPage extends StatelessWidget {
  const HasilSkriningPage({super.key});

  // ── Data hasil berdasarkan tingkat risiko ────────────────────
  // TODO: Sesuaikan rekomendasi dengan yang ditetapkan teman Anda
  static const Map<String, HasilSkriningModel> _dataHasil = {
    'tinggi': HasilSkriningModel(
      tingkat: 'tinggi',
      judul: 'Risiko Tinggi',
      deskripsi: 'Berdasarkan jawaban Anda, tingkat risiko\nTBC Anda adalah tinggi',
      rekomendasi: [
        'Segera konsultasikan dengan dokter atau tenaga medis',
        'Lakukan pemeriksaan dahak dan rontgen dada',
        'Hindari kontak dekat dengan orang lain',
        'Gunakan masker saat berada di tempat umum',
      ],
      warnaBg: Color(0xFFFCECEC),   // pink
      warnaIkon: Colors.red,
      ikon: Icons.error_outline_rounded,
    ),
    'sedang': HasilSkriningModel(
      tingkat: 'sedang',
      judul: 'Risiko Sedang',
      deskripsi: 'Berdasarkan jawaban Anda, tingkat risiko\nTBC Anda adalah sedang',
      rekomendasi: [
        'Konsultasikan gejala Anda dengan dokter',
        'Perhatikan perkembangan gejala Anda',
        'Jaga pola hidup sehat dan istirahat cukup',
        'Tingkatkan daya tahan tubuh dengan nutrisi baik',
      ],
      warnaBg: Color(0xFFFFF2D1),   // kuning
      warnaIkon: Color(0xFFE8824A),
      ikon: Icons.error_outline_rounded,
    ),
    'rendah': HasilSkriningModel(
      tingkat: 'rendah',
      judul: 'Risiko Rendah',
      deskripsi: 'Berdasarkan jawaban Anda, tingkat risiko\nTBC Anda adalah rendah',
      rekomendasi: [
        'Pertahankan gaya hidup sehat Anda',
        'Tetap waspada terhadap gejala TBC',
        'Lakukan pemeriksaan kesehatan rutin',
        'Hindari kontak dengan penderita TBC',
      ],
      warnaBg: Color(0xFFECFFF2),   // hijau
      warnaIkon: AppTheme.buttonBackground,
      ikon: Icons.check_circle_outline_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    // Ambil tingkat risiko dari arguments
    final tingkat =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? 'rendah';
    final hasil = _dataHasil[tingkat] ?? _dataHasil['rendah']!;

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 130.0;
    final double headerTotal = topPadding + headerContentHeight;
    const double cardOverlap = 28.0;
    final double cardTopOffset = headerTotal - cardOverlap;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: Stack(
        children: [

          /// ── HEADER ───────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(context, width, headerTotal, topPadding),
          ),

          /// ── KONTEN SCROLL ────────────────────────────────
          Positioned(
            top: cardTopOffset,
            left: 0, right: 0, bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, 0, width * 0.05, 24),
              child: Column(
                children: [

                  // Card hasil mengambang
                  _buildCardHasil(hasil, width),

                  const SizedBox(height: 20),

                  // Tombol Ulangi Skrining
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.skrining),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonBackground,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Ulangi Skrining',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tombol Kembali ke Beranda
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                            (route) => false,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade400),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kembali Ke Beranda',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info disclaimer
                  _buildDisclaimer(width),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // WIDGET BUILDERS
  // ════════════════════════════════════════════════════════════

  Widget _buildHeader(BuildContext context, double width,
      double headerTotal, double topPadding) {
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
            'Hasil Skrining',
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

  /// Card hasil skrining — warna berbeda per tingkat risiko
  Widget _buildCardHasil(HasilSkriningModel hasil, double width) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.06),
      decoration: BoxDecoration(
        color: hasil.warnaBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [

          // ── Ikon ──────────────────────────────────────────
          Icon(
            hasil.ikon,
            color: hasil.warnaIkon,
            size: 56,
          ),

          const SizedBox(height: 12),

          // ── Judul ─────────────────────────────────────────
          Text(
            hasil.judul,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // ── Deskripsi ─────────────────────────────────────
          Text(
            hasil.deskripsi,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // ── Box Rekomendasi ───────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul rekomendasi
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFE8824A), size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Rekomendasi:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // List rekomendasi
                ...hasil.rekomendasi.map(
                      (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: hasil.warnaIkon,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            r,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Disclaimer di bawah tombol
  Widget _buildDisclaimer(double width) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF71D6F5).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF71D6F5).withOpacity(0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: Colors.blue.shade400, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Skrining ini hanya untuk skrining awal dan bukan diagnosis '
                  'medis. Untuk diagnosis pasti, diperlukan pemeriksaan medis '
                  'oleh tenaga kesehatan profesional.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff115487),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}