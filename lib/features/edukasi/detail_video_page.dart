import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'konten_edukasi_page.dart';

// TODO saat API tersedia:
//   Tambahkan field `videoUrl` di KontenEdukasiModel dari response API.
//   Integrasikan dengan package video_player atau youtube_player_flutter.
//   GET /edukasi/{id} → ambil videoUrl dan deskripsi lengkap

class DetailVideoPage extends StatelessWidget {
  final KontenEdukasiModel konten;

  const DetailVideoPage({super.key, required this.konten});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 100.0;
    final double headerTotal = topPadding + headerContentHeight;
    const double cardOverlap = 28.0;
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
              child: _buildCardVideo(context, width),
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
          Expanded(
            child: Text(
              konten.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.048,
                fontWeight: FontWeight.bold,
                height: 2.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Satu card berisi: player + badge + judul + divider + deskripsi + info
  Widget _buildCardVideo(BuildContext context, double width) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Area Video Player ─────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)),
            child: _buildVideoPlayer(width),
          ),

          // ── Badge + Judul + Divider + Deskripsi + Info ────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Badge Video
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Video',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFE8824A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Judul
                Text(
                  konten.judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Divider
                Divider(color: Colors.grey.shade100, thickness: 1),

                const SizedBox(height: 12),

                // Deskripsi
                Text(
                  konten.deskripsi,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 16),

                // Info koneksi server
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.buttonBackground.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppTheme.buttonBackground, size: 16),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Video akan tersedia setelah koneksi ke server. '
                              'Pastikan koneksi internet Anda aktif.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.buttonBackground,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Placeholder video player.
  /// TODO: Ganti dengan VideoPlayer atau YoutubePlayer saat API tersedia:
  ///
  /// Opsi 1 - Video dari URL biasa (mp4):
  ///   dependency: video_player: ^2.x.x
  ///   Widget: VideoPlayer(controller)
  ///
  /// Opsi 2 - Video dari YouTube:
  ///   dependency: youtube_player_flutter: ^8.x.x
  ///   Widget: YoutubePlayer(controller: YoutubePlayerController(
  ///     initialVideoId: YoutubePlayer.convertUrlToId(konten.videoUrl!),
  ///   ))
  Widget _buildVideoPlayer(double width) {
    return Container(
      width: double.infinity,
      height: width * 0.55,
      color: AppTheme.buttonBackground.withOpacity(0.08),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ikon play
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: AppTheme.buttonBackground,
              size: 36,
            ),
          ),

          // Label placeholder pojok bawah
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Video akan tersedia setelah terhubung ke server',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}