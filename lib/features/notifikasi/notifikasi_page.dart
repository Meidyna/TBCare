import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';
import '../../services/notification_service.dart'; // ← import service

// ════════════════════════════════════════════════════════════════
// CATATAN: NotifikasiModel sekarang ada di notification_service.dart
// Hapus class NotifikasiModel dari file ini jika sebelumnya ada di sini
// ════════════════════════════════════════════════════════════════

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {

  List<NotifikasiModel> _semuaNotifikasi = [];
  bool _isLoading = false;
  String _tabAktif = "Semua";
  final List<String> _tabs = ["Semua", "Belum Dibaca"];

  List<NotifikasiModel> get _notifikasiTerfilter {
    if (_tabAktif == "Belum Dibaca") {
      return _semuaNotifikasi.where((n) => !n.sudahDibaca).toList();
    }
    return _semuaNotifikasi;
  }

  int get _jumlahBelumDibaca =>
      _semuaNotifikasi.where((n) => !n.sudahDibaca).length;

  @override
  void initState() {
    super.initState();
    _loadNotifikasi();
  }

  // ════════════════════════════════════════════════════════════
  // FUNGSI — semua pakai NotificationService (SharedPreferences)
  // ════════════════════════════════════════════════════════════

  Future<void> _loadNotifikasi() async {
    setState(() => _isLoading = true);
    final data = await NotificationService.getHistory();
    setState(() {
      _semuaNotifikasi = data;
      _isLoading = false;
    });
  }

  Future<void> _tandaiDibaca(NotifikasiModel notif) async {
    await NotificationService.tandaiDibaca(notif.id);
    await _loadNotifikasi(); // refresh
  }

  Future<void> _tandaiSemuaDibaca() async {
    await NotificationService.tandaiSemuaDibaca();
    await _loadNotifikasi(); // refresh
  }

  Future<void> _hapusNotifikasi(NotifikasiModel notif) async {
    await NotificationService.hapusDariHistory(notif.id);
    await _loadNotifikasi(); // refresh
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
    const double listPaddingTop = 24.0 + 80.0;

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
                : RefreshIndicator( // ← tarik ke bawah untuk refresh
              onRefresh: _loadNotifikasi,
              child: ListView(
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

  // ════════════════════════════════════════════════════════════
  // WIDGET BUILDERS — sama persis dengan sebelumnya
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: width * 0.02),
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
          if (_jumlahBelumDibaca > 0)
            GestureDetector(
              onTap: _tandaiSemuaDibaca,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          final labelTeks = tab == "Semua"
              ? 'Semua (${_semuaNotifikasi.length})'
              : 'Belum Dibaca ($_jumlahBelumDibaca)';

          return GestureDetector(
            onTap: () => _gantiTab(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isAktif ? AppTheme.buttonBackground : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                labelTeks,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isAktif ? FontWeight.bold : FontWeight.normal,
                  color: isAktif ? Colors.white : Colors.black54,
                ),
              ),
            ),
          );
        }).toList(),
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

  Widget _buildKartuNotifikasi(double width, NotifikasiModel notif) {
    final belumDibaca = !notif.sudahDibaca;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: belumDibaca ? const Color(0x3371D6F5) : Colors.white,
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
          // Ikon berbeda berdasarkan jenis notifikasi
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notif.judul.contains('Diminum')
                  ? AppTheme.buttonBackground  // hijau untuk konfirmasi
                  : const Color(0xFFE8824A),   // oranye untuk pengingat
              shape: BoxShape.circle,
            ),
            child: Icon(
              notif.judul.contains('Diminum')
                  ? Icons.check_circle_outline_rounded
                  : Icons.medication_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif.judul,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  notif.pesan,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      notif.waktuRelatif, // ← pakai getter waktuRelatif
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400),
                    ),
                    const Spacer(),
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
                    GestureDetector(
                      onTap: () => _hapusNotifikasi(notif),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
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