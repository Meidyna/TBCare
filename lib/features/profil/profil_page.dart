import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/session/user_session.dart';
import '../../core/constants/api_constants.dart';
import '../../repositories/profil_repository.dart';
import '../../services/api_services.dart';
import '../../services/notification_service.dart';

class ProfilModel {
  final String nama;
  final String email;
  final String telepon;

  const ProfilModel({
    required this.nama,
    required this.email,
    required this.telepon,
  });
}

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  ProfilModel? _profil;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    setState(() => _isLoading = true);
    try {
      await ProfilRepository.getProfile();
      if (!mounted) return;
      setState(() {
        _profil = ProfilModel(
          nama: UserSession.nama,
          email: UserSession.email,
          telepon: UserSession.telepon,
        );
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _editProfil() async {
    final berubah = await Navigator.pushNamed(context, AppRoutes.editProfil);
    if (berubah == true && mounted) _loadProfil();
  }

  void _pengaturan() {
    Navigator.pushNamed(context, AppRoutes.pengaturan);
  }

  void _keluar() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await _prosesLogout();
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Future<void> _prosesLogout() async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      try {
        await ApiService.post(ApiConstants.logout, {});
      } catch (e) {
        debugPrint('API logout gagal (lanjut hapus sesi lokal): $e');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('foto_profil_${UserSession.email}');

      await NotificationService.hapusSemuaHistory();

      try {
        await NotificationService.batalkanSemuaNotifikasi();
      } catch (e) {
        debugPrint('Gagal batalkan notifikasi: $e');
      }

      await UserSession.hapusToken();
      UserSession.hapus();

    } catch (e) {
      debugPrint('Error tidak terduga saat logout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat keluar: $e')),
        );
      }
    } finally {
      if (mounted) Navigator.of(context).pop();
    }

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 200.0;
    final double headerTotal = topPadding + headerContentHeight;
    const double cardOverlap = 130.0;
    final double cardTopOffset = headerTotal - cardOverlap;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(width, headerTotal, topPadding),
          ),

          Positioned(
            top: cardTopOffset,
            left: 0, right: 0, bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 32),
              child: Column(
                children: [
                  _buildCardProfil(width),
                  SizedBox(height: width * 0.04),
                  _buildTombolOutline(
                    icon: Icons.settings_outlined,
                    label: 'Pengaturan',
                    onTap: _pengaturan,
                    warna: Colors.black87,
                  ),
                  SizedBox(height: width * 0.03),
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground,
              shape: BoxShape.circle,
              image: UserSession.fotoPath.isNotEmpty
                  ? DecorationImage(
                image: FileImage(File(UserSession.fotoPath)),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: UserSession.fotoPath.isEmpty
                ? const Icon(Icons.person_rounded, color: Colors.white, size: 70)
                : null,
          ),

          const SizedBox(height: 12),

          Text(
            profil.nama,
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            profil.email,
            style: TextStyle(fontSize: width * 0.037, color: Colors.grey.shade500),
          ),

          SizedBox(height: width * 0.05),
          Divider(color: Colors.grey.shade100, thickness: 2),
          SizedBox(height: width * 0.04),

          _buildBariInfo(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            nilai: profil.email,
            width: width,
          ),

          SizedBox(height: width * 0.1),

          _buildBariInfo(
            icon: Icons.phone_outlined,
            label: 'Telepon',
            nilai: profil.telepon,
            width: width,
          ),

          SizedBox(height: width * 0.1),

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