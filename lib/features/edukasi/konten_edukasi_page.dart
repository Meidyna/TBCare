import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../repositories/edukasi_repository.dart';

class KontenEdukasiModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String tipe; // "video" | "artikel"
  final String? thumbnailUrl;
  final String? urlVideo;
  final String? isi;

  const KontenEdukasiModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tipe,
    this.thumbnailUrl,
    this.urlVideo,
    this.isi,
  });

  factory KontenEdukasiModel.fromJson(Map<String, dynamic> json) =>
      KontenEdukasiModel(
        id: json['_id'] ?? '',
        judul: json['judul'] ?? '',
        deskripsi: json['deskripsi'] ?? '',
        tipe: json['tipe'] ?? '',
        urlVideo: json['url_video'],
        isi: json['isi'],
      );
}

class KontenEdukasiPage extends StatefulWidget {
  const KontenEdukasiPage({super.key});

  @override
  State<KontenEdukasiPage> createState() => _KontenEdukasiPageState();
}

class _KontenEdukasiPageState extends State<KontenEdukasiPage> {

  List<KontenEdukasiModel> _semuaKonten = [];
  List<KontenEdukasiModel> _kontenTerfilter = [];
  bool _isLoading = false;

  String _tabAktif = "Semua";
  final List<String> _tabs = ["Semua", "Video", "Artikel"];

  @override
  void initState() {
    super.initState();
    _loadKonten();
  }

  Future<void> _loadKonten() async {
    setState(() => _isLoading = true);
    try {
      final data = await EdukasiRepository.getKonten();
      setState(() => _semuaKonten = data);
      _filterKonten();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat konten: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterKonten() {
    setState(() {
      _kontenTerfilter = _tabAktif == "Semua"
          ? _semuaKonten
          : _semuaKonten
          .where((k) => k.tipe.toLowerCase() == _tabAktif.toLowerCase())
          .toList();
    });
  }

  void _gantiTab(String tab) {
    setState(() => _tabAktif = tab);
    _filterKonten();
  }

  void _bukaDetail(KontenEdukasiModel konten) {
    Navigator.pushNamed(
      context,
      konten.tipe.toLowerCase() == 'video'
          ? AppRoutes.detailVideo
          : AppRoutes.detailArtikel,
      arguments: konten,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 100.0;
    final double headerTotal = topPadding + headerContentHeight;
    final double tabTopOffset = headerTotal - 24.0;
    const double listPaddingTop = 28.0 + 40.0;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: Stack(
        children: [

          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(width, headerTotal, topPadding),
          ),

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
            color: isAktif ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            tab,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isAktif ? FontWeight.bold : FontWeight.normal,
              color: isAktif ? AppTheme.buttonBackground : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildKartuKonten(double width, KontenEdukasiModel konten) {
    return GestureDetector(
      onTap: () => _bukaDetail(konten),
      child: Container(
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

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: konten.thumbnailUrl != null
                  ? Image.network(
                konten.thumbnailUrl!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _placeholderThumbnail(konten.tipe),
              )
                  : _placeholderThumbnail(konten.tipe),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    konten.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
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

            Icon(Icons.chevron_right_rounded,
                color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

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
        isVideo
            ? Icons.play_circle_outline_rounded
            : Icons.article_outlined,
        color: AppTheme.buttonBackground,
        size: 28,
      ),
    );
  }
}