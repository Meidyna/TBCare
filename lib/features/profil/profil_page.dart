import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/session/user_session.dart';

// ════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════
class ProfilModel {
  final String nama;
  final String email;
  final String telepon;

  const ProfilModel({
    required this.nama,
    required this.email,
    required this.telepon,
  });

// TODO: Uncomment saat API tersedia
// factory ProfilModel.fromJson(Map<String, dynamic> json) {
//   return ProfilModel(
//     nama: json['nama'],
//     email: json['email'],
//     telepon: json['telepon'] ?? '',
//   );
// }
}

// ════════════════════════════════════════════════════════════════
// PROFIL PAGE
// ════════════════════════════════════════════════════════════════
class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  // ── State ────────────────────────────────────────────────────
  ProfilModel? _profil;
  bool _isLoading = false;

  // ── Lifecycle ────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  // ════════════════════════════════════════════════════════════
  // FUNGSI
  // ════════════════════════════════════════════════════════════

  Future<void> _loadProfil() async {
    setState(() => _isLoading = true);

    // TODO: Ganti dengan pemanggilan API:
    // try {
    //   final response = await ApiService.getProfil();
    //   setState(() {
    //     _profil = ProfilModel.fromJson(response);
    //   });
    // } catch (e) {
    //   // handle error
    // } finally {
    //   setState(() => _isLoading = false);
    // }

    // Sementara pakai data dari UserSession
    // TODO: Hapus simulasi ini saat API tersedia
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _profil = ProfilModel(
        nama: UserSession.nama,
        email: UserSession.email, //
        telepon: UserSession.telepon,  // TODO: ambil dari API
      );
      _isLoading = false;
    });
  }

  void _editProfil() async {
    final berubah = await Navigator.pushNamed(context, AppRoutes.editProfil);
    if (berubah == true) _loadProfil();
  }

  void _pengaturan() {
    // TODO: Navigate ke halaman pengaturan
    // Navigator.pushNamed(context, AppRoutes.pengaturan);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur pengaturan segera hadir')),
    );
  }

  void _keluar() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text(
            'Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Panggil ApiService.logout() jika ada
              UserSession.hapus();
              // Kembali ke halaman login dan hapus semua route sebelumnya
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                    (route) => false,
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 200.0;
    final double headerTotal = topPadding + headerContentHeight;
    // Card overlap ke header — cukup dalam agar avatar masuk ke header
    const double cardOverlap = 130.0;
    final double cardTopOffset = headerTotal - cardOverlap;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [

          /// ── HEADER ───────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(width, headerTotal, topPadding),
          ),

          /// ── KONTEN SCROLL ────────────────────────────
          Positioned(
            top: cardTopOffset,
            left: 0, right: 0, bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, 0, width * 0.05, 32),
              child: Column(
                children: [

                  // Card data diri mengambang
                  _buildCardProfil(width),

                  SizedBox(height: width * 0.04),

                  // Tombol Pengaturan
                  _buildTombolOutline(
                    icon: Icons.settings_outlined,
                    label: 'Pengaturan',
                    onTap: _pengaturan,
                    warna: Colors.black87,
                  ),

                  SizedBox(height: width * 0.03),

                  // Tombol Keluar
                  _buildTombolOutline(
                    icon: Icons.logout_rounded,
                    label: 'Keluar',
                    onTap: _keluar,
                    warna: Colors.red,
                    borderColor: Colors.red.shade300,
                  ),
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

  Widget _buildHeader(double width, double headerTotal, double topPadding) {
    return Container(
      height: headerTotal,
      width: width,
      padding: EdgeInsets.only(top: topPadding + 16),
      decoration: const BoxDecoration(color: AppTheme.buttonBackground),
      child: Text(
        'Profil Saya',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: width * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Card data diri — overlap ke header dengan shadow
  Widget _buildCardProfil(double width) {
    final profil = _profil;
    if (profil == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [

          // ── Avatar ────────────────────────────────────────
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppTheme.buttonBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 70,
            ),
          ),

          const SizedBox(height: 12),

          // ── Nama ──────────────────────────────────────────
          Text(
            profil.nama,
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          // ── Email singkat di bawah nama ───────────────────
          Text(
            profil.email,
            style: TextStyle(
              fontSize: width * 0.037,
              color: Colors.grey.shade500,
            ),
          ),

          SizedBox(height: width * 0.05),

          // ── Divider ───────────────────────────────────────
          Divider(color: Colors.grey.shade100, thickness: 2),

          SizedBox(height: width * 0.04),

          // ── Baris info Email ──────────────────────────────
          _buildBariInfo(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            nilai: profil.email,
            width: width,
          ),

          SizedBox(height: width * 0.1),

          // ── Baris info Telepon ────────────────────────────
          _buildBariInfo(
            icon: Icons.phone_outlined,
            label: 'Telepon',
            nilai: profil.telepon,
            width: width,
          ),

          SizedBox(height: width * 0.1),

          // ── Tombol Edit Profil ────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _editProfil,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit Profil'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: BorderSide(color: Colors.grey.shade300),
                backgroundColor: AppTheme.mainBackground,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Baris satu info (ikon + label + nilai)
  Widget _buildBariInfo({
    required IconData icon,
    required String label,
    required String nilai,
    required double width,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              nilai,
              style: TextStyle(
                fontSize: width * 0.036,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Tombol outline generik (Pengaturan / Keluar)
  Widget _buildTombolOutline({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color warna,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: warna),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: warna,
          side: BorderSide(color: borderColor ?? Colors.grey.shade300),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}