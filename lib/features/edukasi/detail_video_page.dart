import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../core/constants/api_constants.dart';
import '../../core/theme/app_theme.dart';
import 'konten_edukasi_page.dart';

class DetailVideoPage extends StatefulWidget {
  final KontenEdukasiModel konten;

  const DetailVideoPage({super.key, required this.konten});

  @override
  State<DetailVideoPage> createState() => _DetailVideoPageState();
}

class _DetailVideoPageState extends State<DetailVideoPage> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (widget.konten.urlVideo == null || widget.konten.urlVideo!.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    try {
      // Gabungkan baseUrl + path video
      final videoUrl = widget.konten.urlVideo!;
      debugPrint('VIDEO URL: $videoUrl');
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _controller!.initialize();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller == null) return;
    setState(() {
      _controller!.value.isPlaying
          ? _controller!.pause()
          : _controller!.play();
    });
  }

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
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 32),
              child: _buildCardVideo(context, width),
            ),
          ),
        ],
      ),
    );
  }

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
              widget.konten.judul,
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _buildVideoPlayer(width),
          ),

          // ── Badge + Judul + Divider + Deskripsi ──────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Badge Video
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

                Text(
                  widget.konten.judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade100, thickness: 1),
                const SizedBox(height: 12),

                Text(
                  widget.konten.deskripsi,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(double width) {
    // Loading
    if (_isLoading) {
      return Container(
        width: double.infinity,
        height: width * 0.55,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    // Error / tidak ada video
    if (_hasError || _controller == null) {
      return Container(
        width: double.infinity,
        height: width * 0.55,
        color: AppTheme.buttonBackground.withOpacity(0.08),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_off_rounded,
                  color: AppTheme.buttonBackground, size: 40),
              SizedBox(height: 8),
              Text(
                'Video tidak tersedia',
                style: TextStyle(
                  color: AppTheme.buttonBackground,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Video player
    return GestureDetector(
      onTap: _togglePlay,
      child: Container(
        width: double.infinity,
        height: width * 0.55,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),

            // Tombol play/pause overlay
            ValueListenableBuilder(
              valueListenable: _controller!,
              builder: (context, value, child) {
                return AnimatedOpacity(
                  opacity: value.isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                );
              },
            ),

            // Progress bar di bawah
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                valueListenable: _controller!,
                builder: (context, value, child) {
                  return VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: AppTheme.buttonBackground,
                      bufferedColor: Colors.white30,
                      backgroundColor: Colors.white10,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}