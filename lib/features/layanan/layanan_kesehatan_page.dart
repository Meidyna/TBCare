import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';

// ════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════
class LayananKesehatanModel {
  final String id;
  final String nama;
  final String tipe; // "Puskesmas" | "Rumah Sakit" | "Klinik"
  final String alamat;
  final String jamOperasional;
  final String telepon;

  const LayananKesehatanModel({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.alamat,
    required this.jamOperasional,
    required this.telepon,
  });

// TODO: Uncomment saat API tersedia
// factory LayananKesehatanModel.fromJson(Map<String, dynamic> json) {
//   return LayananKesehatanModel(
//     id: json['id'].toString(),
//     nama: json['nama'],
//     tipe: json['tipe'],
//     alamat: json['alamat'],
//     jamOperasional: json['jam_operasional'],
//     telepon: json['telepon'],
//   );
// }
}

// ════════════════════════════════════════════════════════════════
// PAGE
// ════════════════════════════════════════════════════════════════
class LayananKesehatanPage extends StatefulWidget {
  const LayananKesehatanPage({super.key});

  @override
  State<LayananKesehatanPage> createState() => _LayananKesehatanPageState();
}

class _LayananKesehatanPageState extends State<LayananKesehatanPage> {

  // ── State ────────────────────────────────────────────────────

  /// Semua data layanan dari API
  /// Kosong dulu karena API belum ada
  List<LayananKesehatanModel> _semuaLayanan = [];

  /// Hasil filter berdasarkan search
  List<LayananKesehatanModel> _layananTerfilter = [];

  bool _isLoading = false;

  final _searchController = TextEditingController();

  // ── Data dummy sementara ─────────────────────────────────────
  // TODO: Hapus data dummy ini saat API sudah tersedia
  final List<LayananKesehatanModel> _dataDummy = const [
    LayananKesehatanModel(
      id: '1',
      nama: 'Puskesmas Kramat Jati',
      tipe: 'Puskesmas',
      alamat: 'Jl. Dewi Sartika No.14, Jakarta Timur',
      jamOperasional: '08:00 - 16:00',
      telepon: '021-80294728',
    ),
    LayananKesehatanModel(
      id: '2',
      nama: 'RS Persahabatan',
      tipe: 'Rumah Sakit',
      alamat: 'Jl. Persahabatan Raya No.1, Jakarta Timur',
      jamOperasional: '24 Jam',
      telepon: '021-930745638',
    ),
    LayananKesehatanModel(
      id: '3',
      nama: 'Klinik TB Sehat Sentosa',
      tipe: 'Klinik',
      alamat: 'Jl. Raya Bogor Km 20, Jakarta Timur',
      jamOperasional: '09:00 - 17:00',
      telepon: '021-94883940',
    ),
    LayananKesehatanModel(
      id: '4',
      nama: 'Puskesmas Cipayung',
      tipe: 'Puskesmas',
      alamat: 'Jl. Raya Cipayung, Jakarta Timur',
      jamOperasional: '08:00 - 14:00',
      telepon: '021-3874945',
    ),
  ];

  // ── Lifecycle ────────────────────────────────────────────────

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

  // ════════════════════════════════════════════════════════════
  // FUNGSI — ganti bagian TODO saat API tersedia
  // ════════════════════════════════════════════════════════════

  /// Load daftar layanan kesehatan dari API
  Future<void> _loadLayanan() async {
    setState(() => _isLoading = true);

    // TODO: Ganti dengan pemanggilan API, contoh:
    // try {
    //   final response = await ApiService.getLayananKesehatan();
    //   setState(() {
    //     _semuaLayanan = (response as List)
    //         .map((e) => LayananKesehatanModel.fromJson(e))
    //         .toList();
    //     _layananTerfilter = _semuaLayanan;
    //   });
    // } catch (e) {
    //   // handle error
    // } finally {
    //   setState(() => _isLoading = false);
    // }

    // Sementara pakai data dummy
    // TODO: Hapus baris ini saat API sudah tersedia
    await Future.delayed(const Duration(milliseconds: 300)); // simulasi loading
    setState(() {
      _semuaLayanan = _dataDummy;
      _layananTerfilter = _dataDummy;
      _isLoading = false;
    });
  }

  /// Filter layanan berdasarkan teks pencarian
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

    // Sama persis dengan jadwal_page untuk konsistensi
    const double headerContentHeight = 100.0;
    final double headerTotal = topPadding + headerContentHeight;
    // Search bar overlap ke header (setengah di dalam, setengah di luar)
    final double searchTopOffset = headerTotal - 28.0;
    // Tinggi search bar ~56, separuh bawah = 28, + gap
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
                // Hasil kosong saat search tidak ketemu
                if (_layananTerfilter.isEmpty)
                  _buildEmpty()
                else
                  ..._layananTerfilter
                      .map((l) => _buildKartuLayanan(width, l)),

                SizedBox(height: height * 0.1),
              ],
            ),
          ),

          /// ── SEARCH BAR (mengambang overlap header) ─────────
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

  /// Search bar mengambang dengan shadow
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
          hintStyle:
          TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: const Icon(Icons.location_on_outlined,
              color: AppTheme.buttonBackground, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close,
                size: 18, color: Colors.grey.shade400),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  /// Tampilan saat tidak ada hasil pencarian
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

  /// Kartu satu layanan kesehatan
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

                // Nama
                Text(
                  layanan.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                // Badge tipe
                _buildBadgeTipe(layanan.tipe),

                const SizedBox(height: 8),

                // Divider tipis
                Divider(color: Colors.grey.shade100, height: 1),

                const SizedBox(height: 8),

                // Alamat
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  teks: layanan.alamat,
                ),

                const SizedBox(height: 4),

                // Jam operasional
                _buildInfoRow(
                  icon: Icons.access_time_rounded,
                  teks: layanan.jamOperasional,
                ),

                const SizedBox(height: 4),

                // Telepon
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

  /// Badge warna berdasarkan tipe layanan
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

  /// Baris info (ikon + teks)
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

  /// Ikon berdasarkan tipe layanan
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