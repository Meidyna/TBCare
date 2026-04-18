import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/layanan_kesehatan_model.dart';
import '../../repositories/layanan_kesehatan_repository.dart';

class LayananKesehatanPage extends StatefulWidget {
  const LayananKesehatanPage({super.key});

  @override
  State<LayananKesehatanPage> createState() => _LayananKesehatanPageState();
}

class _LayananKesehatanPageState extends State<LayananKesehatanPage> {

  List<LayananKesehatanModel> _semuaLayanan = [];
  List<LayananKesehatanModel> _layananTerfilter = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLayanan();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLayanan({bool loadMore = false}) async {
    if (loadMore) {
      setState(() => _isLoadingMore = true);
    } else {
      setState(() => _isLoading = true);
      _currentPage = 1;
    }

    try {
      final data = await LayananRepository.getLayanan(page: _currentPage);
      setState(() {
        if (loadMore) {
          _semuaLayanan.addAll(data);
        } else {
          _semuaLayanan = data;
        }
        _layananTerfilter = _semuaLayanan;
        _hasMoreData = data.length >= 20;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMore() async {
    _currentPage++;
    await _loadLayanan(loadMore: true);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _layananTerfilter = _semuaLayanan;
      } else {
        _layananTerfilter = _semuaLayanan
            .where((l) =>
        l.nama.toLowerCase().contains(query) ||
            l.tipe.toLowerCase().contains(query) ||
            l.alamat.toLowerCase().contains(query))
            .toList();
      }
    });
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
    final double searchTopOffset = headerTotal - 28.0;
    const double listPaddingTop = 28.0 + 40.0;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: Stack(
        children: [

          /// ── HEADER ─────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(width, headerTotal, topPadding),
          ),

          /// ── KONTEN SCROLL ──────────────────────────────────
          Positioned(
            top: searchTopOffset,
            left: 0, right: 0, bottom: 0,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, listPaddingTop, width * 0.05, 0),
              children: [

                // Hasil kosong
                if (_layananTerfilter.isEmpty)
                  _buildEmpty()
                else
                  ..._layananTerfilter
                      .map((l) => _buildKartuLayanan(width, l)),

                // Tombol Load More (hanya tampil saat tidak sedang search)
                if (_hasMoreData && _searchController.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _isLoadingMore
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _loadMore,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.buttonBackground,
                          side: const BorderSide(
                              color: AppTheme.buttonBackground),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Muat Lebih Banyak',
                          style: TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: height * 0.1),
              ],
            ),
          ),

          /// ── SEARCH BAR ─────────────────────────────────────
          Positioned(
            top: searchTopOffset,
            left: width * 0.05,
            right: width * 0.05,
            child: _buildSearchBar(),
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
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: width * 0.02),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Layanan Kesehatan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Temukan fasilitas kesehatan terdekat",
                style: TextStyle(
                    color: Colors.white70, fontSize: width * 0.032),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Cari nama layanan kesehatan...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: const Icon(Icons.location_on_outlined,
              color: AppTheme.buttonBackground, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close,
                size: 18, color: Colors.grey.shade400),
            onPressed: () => _searchController.clear(),
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          Icon(Icons.search_off_rounded,
              size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            _searchController.text.isEmpty
                ? 'Belum ada data layanan kesehatan.'
                : 'Layanan "${_searchController.text}" tidak ditemukan.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade500, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildKartuLayanan(double width, LayananKesehatanModel layanan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Ikon tipe layanan ─────────────────────────────
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _ikonTipe(layanan.tipe),
              color: AppTheme.buttonBackground,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // ── Info layanan ──────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  layanan.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                _buildBadgeTipe(layanan.tipe),
                const SizedBox(height: 8),
                Divider(color: Colors.grey.shade100, height: 1),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  teks: layanan.alamat,
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  icon: Icons.access_time_rounded,
                  teks: layanan.jamOperasional,
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  icon: Icons.phone_outlined,
                  teks: layanan.telepon,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTipe(String tipe) {
    Color bgColor;
    Color textColor;

    switch (tipe) {
      case 'Puskesmas':
        bgColor = const Color(0xFFE8F3EF);
        textColor = AppTheme.buttonBackground;
        break;
      case 'Rumah Sakit':
        bgColor = const Color(0xFFFFF0E6);
        textColor = const Color(0xFFE8824A);
        break;
      case 'Klinik':
        bgColor = const Color(0xFFFFF9E6);
        textColor = const Color(0xFFD4A017);
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tipe,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String teks}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            teks,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  IconData _ikonTipe(String tipe) {
    switch (tipe) {
      case 'Puskesmas':
        return Icons.medical_services_outlined;
      case 'Rumah Sakit':
        return Icons.local_hospital_outlined;
      case 'Klinik':
        return Icons.healing_outlined;
      default:
        return Icons.health_and_safety_outlined;
    }
  }
}