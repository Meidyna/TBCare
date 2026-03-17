import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════
// TENTANG APLIKASI PAGE
// Halaman ini sepenuhnya statis — tidak memerlukan API
// ════════════════════════════════════════════════════════════════
class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 130.0;
    final double headerTotal = topPadding + headerContentHeight;
    const double cardOverlap = 40.0;
    final double cardTopOffset = headerTotal - cardOverlap;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: Stack(
        children: [

          /// ── HEADER ─────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(context, width, headerTotal, topPadding),
          ),

          /// ── KONTEN SCROLL ──────────────────────────────────
          Positioned(
            top: cardTopOffset,
            left: 0, right: 0, bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, 0, width * 0.05, 32),
              child: Column(
                children: [

                  // Card identitas aplikasi
                  _buildCardIdentitas(width),

                  const SizedBox(height: 16),

                  // Card deskripsi
                  _buildCardDeskripsi(width),

                  const SizedBox(height: 16),

                  // Fitur utama
                  _buildSectionLabel('FITUR UTAMA'),
                  const SizedBox(height: 8),
                  _buildCardFitur(width),

                  const SizedBox(height: 16),

                  // Disclaimer
                  _buildCardDisclaimer(width),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: width * 0.02),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'TBCare - Asisten Digital Anda',
                style: TextStyle(
                    color: Colors.white70, fontSize: width * 0.030),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card logo + nama + versi + tagline
  Widget _buildCardIdentitas(double width) {
    return _card(
      child: Column(
        children: [
          // Logo aplikasi
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),

          const SizedBox(height: 12),

          // Nama aplikasi
          const Text(
            'TBCare',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          // Tagline
          Text(
            'Aplikasi pendamping untuk pasien Tuberculosis',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          // Badge versi
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Versi 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.buttonBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card deskripsi singkat aplikasi
  Widget _buildCardDeskripsi(double width) {
    return _card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/icons/target.png',
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'TBCare hadir untuk membantu pasien Tuberculosis dalam '
                  'mengelola pengobatan mereka secara teratur dan efektif. '
                  'Kami berkomitmen mendukung perjalanan kesembuhan Anda '
                  'dengan teknologi yang mudah digunakan.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String teks) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        teks,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Card daftar fitur utama
  Widget _buildCardFitur(double width) {
    const fitur = [
      _FiturData(
        label: 'Pengingat Jadwal Obat',
        deskripsi: 'Notifikasi tepat waktu agar tidak lupa minum obat',
      ),
      _FiturData(
        label: 'Skrining Mandiri',
        deskripsi: 'Evaluasi risiko dan gejala tuberculosis',
      ),
      _FiturData(
        label: 'Chatbot Kesehatan',
        deskripsi: 'Asisten virtual untuk menjawab pertanyaan Anda',
      ),
      _FiturData(
        label: 'Layanan Kesehatan',
        deskripsi: 'Informasi fasilitas kesehatan yang tersedia',
      ),
      _FiturData(
        label: 'Konten Edukasi',
        deskripsi: 'Artikel dan video informasi seputar TBC',
      ),
    ];

    return _card(
      child: Column(
        children: fitur.asMap().entries.map((entry) {
          final isLast = entry.key == fitur.length - 1;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.buttonBackground,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.deskripsi,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// Card disclaimer
  Widget _buildCardDisclaimer(double width) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2D1), // kuning muda
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8C96A).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFD4A017), size: 18),
              SizedBox(width: 8),
              Text(
                'Disclaimer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Aplikasi ini bukan pengganti konsultasi medis profesional. '
                'Selalu konsultasikan kondisi kesehatan Anda dengan dokter '
                'atau tenaga kesehatan yang berkompeten. Informasi dalam '
                'aplikasi ini bersifat edukatif dan tidak dimaksudkan sebagai '
                'diagnosis atau pengobatan.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Wrapper card putih dengan border + shadow
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Helper class data fitur ──────────────────────────────────────
class _FiturData {
  final String label;
  final String deskripsi;
  const _FiturData({required this.label, required this.deskripsi});
}