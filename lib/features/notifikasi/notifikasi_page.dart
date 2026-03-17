import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';

// ════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════
class NotifikasiModel {
  final String id;
  final String judul;
  final String pesan;
  final String waktu;
  bool sudahDibaca;

  NotifikasiModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.waktu,
    this.sudahDibaca = false,
  });

// TODO: Uncomment saat API tersedia
// factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
//   return NotifikasiModel(
//     id: json['id'].toString(),
//     judul: json['judul'],
//     pesan: json['pesan'],
//     waktu: json['waktu'],
//     sudahDibaca: json['sudah_dibaca'] ?? false,
//   );
// }
}

// ════════════════════════════════════════════════════════════════
// PAGE
// ════════════════════════════════════════════════════════════════
class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {

  // ── State ────────────────────────────────────────────────────
  List<NotifikasiModel> _semuaNotifikasi = [];
  bool _isLoading = false;

  /// Tab aktif: "Semua" | "Belum Dibaca"
  String _tabAktif = "Semua";
  final List<String> _tabs = ["Semua", "Belum Dibaca"];

  // ── Data dummy sementara ─────────────────────────────────────
  // TODO: Hapus data dummy ini saat API tersedia
  final List<NotifikasiModel> _dataDummy = [
    NotifikasiModel(
      id: '1',
      judul: 'Waktunya Minum Obat',
      pesan: 'Rifampisin 450mg - Jangan lupa minum obat sesuai jadwal',
      waktu: '2 Jam yang lalu',
      sudahDibaca: false,
    ),
    NotifikasiModel(
      id: '2',
      judul: 'Obat Diminum',
      pesan: 'Anda telah menyelesaikan dosis pagi hari ini. Lanjutkan!',
      waktu: '2 Hari yang lalu',
      sudahDibaca: true,
    ),
  ];

  // ── Getters ──────────────────────────────────────────────────
  List<NotifikasiModel> get _notifikasiTerfilter {
    if (_tabAktif == "Belum Dibaca") {
      return _semuaNotifikasi.where((n) => !n.sudahDibaca).toList();
    }
    return _semuaNotifikasi;
  }

  int get _jumlahBelumDibaca =>
      _semuaNotifikasi.where((n) => !n.sudahDibaca).length;

  // ── Lifecycle ────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadNotifikasi();
  }

  // ════════════════════════════════════════════════════════════
  // FUNGSI
  // ════════════════════════════════════════════════════════════

  Future<void> _loadNotifikasi() async {
    setState(() => _isLoading = true);

    // TODO: Ganti dengan pemanggilan API:
    // try {
    //   final response = await ApiService.getNotifikasi();
    //   setState(() {
    //     _semuaNotifikasi = (response as List)
    //         .map((e) => NotifikasiModel.fromJson(e))
    //         .toList();
    //   });
    // } catch (e) {
    //   // handle error
    // } finally {
    //   setState(() => _isLoading = false);
    // }

    // Sementara pakai data dummy
    // TODO: Hapus simulasi ini saat API tersedia
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _semuaNotifikasi = _dataDummy;
      _isLoading = false;
    });
  }

  /// Tandai satu notifikasi sebagai sudah dibaca
  void _tandaiDibaca(NotifikasiModel notif) {
    setState(() => notif.sudahDibaca = true);
    // TODO: await ApiService.tandaiDibaca(notif.id);
  }

  /// Tandai semua notifikasi sebagai sudah dibaca
  void _tandaiSemuaDibaca() {
    setState(() {
      for (final n in _semuaNotifikasi) {
        n.sudahDibaca = true;
      }
    });
    // TODO: await ApiService.tandaiSemuaDibaca();
  }

  /// Hapus satu notifikasi
  void _hapusNotifikasi(NotifikasiModel notif) {
    setState(() => _semuaNotifikasi.removeWhere((n) => n.id == notif.id));
    // TODO: await ApiService.hapusNotifikasi(notif.id);
  }

  void _gantiTab(String tab) => setState(() => _tabAktif = tab);

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
    final double tabTopOffset = headerTotal - 24.0;
    // Tab bar vertikal ~96px (2 item x 44px + padding), separuh overlap = 24
    const double listPaddingTop = 24.0 + 80.0;

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
            top: tabTopOffset,
            left: 0, right: 0, bottom: 0,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, listPaddingTop, width * 0.05, 0),
              children: [
                if (_notifikasiTerfilter.isEmpty)
                  _buildEmpty()
                else
                  ..._notifikasiTerfilter
                      .map((n) => _buildKartuNotifikasi(width, n)),

                SizedBox(height: height * 0.1),
              ],
            ),
          ),

          /// ── TAB BAR MENGAMBANG ──────────────────────────────
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
        right: width * 0.04,
        bottom: 8,
      ),
      decoration: const BoxDecoration(color: AppTheme.buttonBackground),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tombol back ke beranda
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: width * 0.02),

          // Judul + subjudul
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _jumlahBelumDibaca == 0
                      ? 'Semua notifikasi sudah dibaca'
                      : '$_jumlahBelumDibaca notifikasi belum dibaca',
                  style: TextStyle(
                      color: Colors.white70, fontSize: width * 0.032),
                ),
              ],
            ),
          ),

          // Tombol Tandai Semua
          if (_jumlahBelumDibaca > 0)
            GestureDetector(
              onTap: _tandaiSemuaDibaca,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.done_all_rounded,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Tandai Semua',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.028,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Tab bar Semua / Belum Dibaca — mengambang dengan shadow, susunan atas bawah
  Widget _buildTabBar() {
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
      padding: const EdgeInsets.all(4),
      child: Column(
        children: _tabs.map((tab) {
          final isAktif = _tabAktif == tab;

          String labelTeks;
          if (tab == "Semua") {
            labelTeks = 'Semua (${_semuaNotifikasi.length})';
          } else {
            labelTeks = 'Belum Dibaca ($_jumlahBelumDibaca)';
          }

          return GestureDetector(
            onTap: () => _gantiTab(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isAktif
                    ? AppTheme.buttonBackground
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                labelTeks,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                  isAktif ? FontWeight.bold : FontWeight.normal,
                  color: isAktif ? Colors.white : Colors.black54,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Tampilan saat tidak ada notifikasi
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
          Icon(Icons.notifications_none_rounded,
              size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            _tabAktif == "Belum Dibaca"
                ? 'Tidak ada notifikasi yang belum dibaca.'
                : 'Belum ada notifikasi.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade500, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  /// Kartu satu notifikasi
  Widget _buildKartuNotifikasi(double width, NotifikasiModel notif) {
    final belumDibaca = !notif.sudahDibaca;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        // Belum dibaca: biru muda #71D6F5 opacity 20%
        // Sudah dibaca: putih
        color: belumDibaca
            ? const Color(0x3371D6F5)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: belumDibaca
              ? const Color(0xFF71D6F5).withOpacity(0.6)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Ikon notifikasi ───────────────────────────────
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE8824A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medication_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // ── Konten ────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  notif.judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                // Pesan
                Text(
                  notif.pesan,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                // Waktu + aksi
                Row(
                  children: [
                    Text(
                      notif.waktu,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const Spacer(),
                    // Tombol "Tandai Dibaca" hanya untuk yang belum dibaca
                    if (belumDibaca) ...[
                      GestureDetector(
                        onTap: () => _tandaiDibaca(notif),
                        child: Text(
                          'Tandai Dibaca',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.buttonBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    // Tombol Hapus
                    GestureDetector(
                      onTap: () => _hapusNotifikasi(notif),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}