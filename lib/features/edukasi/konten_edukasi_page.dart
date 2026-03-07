import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════
class KontenEdukasiModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String tipe; // "Artikel" | "Video"
  final String? thumbnailUrl; // URL gambar dari API

  const KontenEdukasiModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tipe,
    this.thumbnailUrl,
  });

// TODO: Uncomment saat API tersedia
// factory KontenEdukasiModel.fromJson(Map<String, dynamic> json) {
//   return KontenEdukasiModel(
//     id: json['id'].toString(),
//     judul: json['judul'],
//     deskripsi: json['deskripsi'],
//     tipe: json['tipe'], // "Artikel" atau "Video"
//     thumbnailUrl: json['thumbnail_url'],
//   );
// }
}

// ════════════════════════════════════════════════════════════════
// PAGE
// ════════════════════════════════════════════════════════════════
class KontenEdukasiPage extends StatefulWidget {
  const KontenEdukasiPage({super.key});

  @override
  State<KontenEdukasiPage> createState() => _KontenEdukasiPageState();
}

class _KontenEdukasiPageState extends State<KontenEdukasiPage> {

  // ── State ────────────────────────────────────────────────────
  List<KontenEdukasiModel> _semuaKonten = [];
  List<KontenEdukasiModel> _kontenTerfilter = [];
  bool _isLoading = false;

  /// Tab aktif: "Semua" | "Video" | "Artikel"
  String _tabAktif = "Semua";
  final List<String> _tabs = ["Semua", "Video", "Artikel"];

  // ── Data dummy ───────────────────────────────────────────────
  // TODO: Hapus data dummy ini saat API sudah tersedia
  final List<KontenEdukasiModel> _dataDummy = const [
    KontenEdukasiModel(
      id: '1',
      judul: 'Mengenal Tuberkulosis',
      deskripsi: 'Penjelasan lengkap tentang apa itu TBC, penyebabs dan cara penularannya',
      tipe: 'Artikel',
    ),
    KontenEdukasiModel(
      id: '2',
      judul: 'Cara Minum Obat TBC yang Benar',
      deskripsi: 'Tutorial langkah demi langkah mengkonsumsi obat TBC dengan tepat',
      tipe: 'Video',
    ),
    KontenEdukasiModel(
      id: '3',
      judul: 'Mitos dan Fakta Seputar TBC',
      deskripsi: 'Memahami apa saja yang termasuk mitos dan apa saja yang termasuk fakta pada TBC',
      tipe: 'Artikel',
    ),
    KontenEdukasiModel(
      id: '4',
      judul: 'Pentingnya Nutrisi Untuk Pasien TBC',
      deskripsi: 'Memahami nutrisi apa saja yang penting untuk pasien Tuberkulosis',
      tipe: 'Artikel',
    ),
    KontenEdukasiModel(
      id: '5',
      judul: 'Pencegahan Penularan TBC',
      deskripsi: 'Tips dan cara mencegah penyebaran TBC ke orang lain',
      tipe: 'Video',
    ),
  ];

  // ── Lifecycle ────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadKonten();
  }

  // ════════════════════════════════════════════════════════════
  // FUNGSI
  // ════════════════════════════════════════════════════════════

  /// Load konten dari API
  Future<void> _loadKonten() async {
    setState(() => _isLoading = true);

    // TODO: Ganti dengan pemanggilan API, contoh:
    // try {
    //   final response = await ApiService.getKontenEdukasi();
    //   setState(() {
    //     _semuaKonten = (response as List)
    //         .map((e) => KontenEdukasiModel.fromJson(e))
    //         .toList();
    //   });
    // } catch (e) {
    //   // handle error
    // } finally {
    //   setState(() => _isLoading = false);
    //   _filterKonten();
    // }

    // Sementara pakai data dummy
    // TODO: Hapus baris ini saat API sudah tersedia
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _semuaKonten = _dataDummy;
      _isLoading = false;
    });
    _filterKonten();
  }

  /// Filter konten berdasarkan tab aktif
  void _filterKonten() {
    setState(() {
      if (_tabAktif == "Semua") {
        _kontenTerfilter = _semuaKonten;
      } else {
        _kontenTerfilter = _semuaKonten
            .where((k) => k.tipe == _tabAktif)
            .toList();
      }
    });
  }

  void _gantiTab(String tab) {
    setState(() => _tabAktif = tab);
    _filterKonten();
  }

  // ════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 100.0;
    final double headerTotal = topPadding + headerContentHeight;
    // Tab bar overlap ke header (setengah di dalam, setengah di luar)
    final double tabTopOffset = headerTotal - 24.0;
    // Tinggi tab bar ~48, separuh bawah = 24, + gap
    const double listPaddingTop = 28.0 + 40.0;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: Stack(
        children: [

          /// ── HEADER ───────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(width, headerTotal, topPadding),
          ),

          /// ── KONTEN SCROLL ────────────────────────────────────
          Positioned(
            top: tabTopOffset,
            left: 0, right: 0, bottom: 0,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, listPaddingTop, width * 0.05, 0),
              children: [
                if (_kontenTerfilter.isEmpty)
                  _buildEmpty()
                else
                  ..._kontenTerfilter
                      .map((k) => _buildKartuKonten(width, k)),

                SizedBox(height: height * 0.1),
              ],
            ),
          ),

          /// ── TAB BAR MENGAMBANG ────────────────────────────────
          Positioned(
            top: tabTopOffset,
            left: width * 0.05,
            right: width * 0.05,
            child: _buildTabBar(),
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
        bottom: 8,
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
                "Konten Edukasi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Pelajari lebih lanjut tentang TBC",
                style: TextStyle(
                    color: Colors.white70, fontSize: width * 0.032),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.authBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: _tabs.map((tab) => _buildTabItem(tab)).toList(),
      ),
    );
  }

  Widget _buildTabItem(String tab) {
    final isAktif = _tabAktif == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => _gantiTab(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            // Tab aktif pakai warna hijau, tidak aktif transparan
            color: isAktif ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            tab,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight:
              isAktif ? FontWeight.bold : FontWeight.normal,
              // Tab aktif teks putih, tidak aktif abu-abu
              color: isAktif ? Colors.black54 : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  /// Tampilan saat tidak ada konten
  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.article_outlined, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Belum ada konten untuk kategori "$_tabAktif".',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade500, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  /// Kartu satu konten edukasi
  Widget _buildKartuKonten(double width, KontenEdukasiModel konten) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ── Thumbnail / placeholder ─────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: konten.thumbnailUrl != null
            // Saat API ada, tampilkan gambar dari URL
                ? Image.network(
              konten.thumbnailUrl!,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderThumbnail(konten.tipe),
            )
            // Sementara pakai placeholder
                : _placeholderThumbnail(konten.tipe),
          ),

          const SizedBox(width: 12),

          // ── Judul & deskripsi ───────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  konten.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  konten.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Placeholder thumbnail saat gambar belum ada dari API
  Widget _placeholderThumbnail(String tipe) {
    final bool isVideo = tipe == 'Video';
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.buttonBackground.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isVideo ? Icons.play_circle_outline_rounded : Icons.article_outlined,
        color: AppTheme.buttonBackground,
        size: 28,
      ),
    );
  }
}