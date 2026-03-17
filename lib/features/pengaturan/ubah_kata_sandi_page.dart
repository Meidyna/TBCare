import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════
// UBAH KATA SANDI PAGE
// ════════════════════════════════════════════════════════════════
class UbahKataSandiPage extends StatefulWidget {
  const UbahKataSandiPage({super.key});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {

  // ── Controllers ──────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _sandiLamaController  = TextEditingController();
  final _sandiBaruController  = TextEditingController();
  final _konfirmasiController = TextEditingController();

  // ── State visibilitas password ────────────────────────────────
  bool _lihatSandiLama    = false;
  bool _lihatSandiBaru    = false;
  bool _lihatKonfirmasi   = false;
  bool _isSaving          = false;

  @override
  void dispose() {
    _sandiLamaController.dispose();
    _sandiBaruController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  // FUNGSI
  // ════════════════════════════════════════════════════════════

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // TODO: Ganti dengan pemanggilan API saat tersedia:
    // try {
    //   await ApiService.ubahKataSandi(
    //     sandiLama: _sandiLamaController.text,
    //     sandiBaru: _sandiBaruController.text,
    //   );
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Kata sandi berhasil diubah')),
    //     );
    //     Navigator.pop(context);
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Gagal mengubah kata sandi. Coba lagi.')),
    //   );
    // } finally {
    //   setState(() => _isSaving = false);
    // }

    // Sementara simulasi loading
    // TODO: Hapus simulasi ini saat API tersedia
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Fitur ini akan tersedia setelah server terhubung')),
      );
    }
  }

  // ════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 130.0;
    final double headerTotal = topPadding + headerContentHeight;
    const double cardOverlap = 50.0;
    final double cardTopOffset = headerTotal - cardOverlap;

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
            top: cardTopOffset,
            left: 0, right: 0, bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, 0, width * 0.05, 32),
              child: _buildCardForm(width),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubah Kata Sandi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pastikan kata sandi Anda kuat dan aman',
                style: TextStyle(
                    color: Colors.white70, fontSize: width * 0.030),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card form ubah kata sandi
  Widget _buildCardForm(double width) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Kata Sandi Saat Ini ──────────────────────────
            _label('Kata Sandi Saat Ini'),
            const SizedBox(height: 6),
            _fieldPassword(
              controller: _sandiLamaController,
              hint: 'Masukkan kata sandi',
              lihat: _lihatSandiLama,
              onToggleLihat: () =>
                  setState(() => _lihatSandiLama = !_lihatSandiLama),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Kata sandi saat ini tidak boleh kosong';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ── Kata Sandi Baru ──────────────────────────────
            _label('Kata Sandi Baru'),
            const SizedBox(height: 6),
            _fieldPassword(
              controller: _sandiBaruController,
              hint: 'Masukkan kata sandi',
              lihat: _lihatSandiBaru,
              onToggleLihat: () =>
                  setState(() => _lihatSandiBaru = !_lihatSandiBaru),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Kata sandi baru tidak boleh kosong';
                }
                if (v.length < 8) {
                  return 'Kata sandi minimal 8 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ── Konfirmasi Kata Sandi Baru ───────────────────
            _label('Konfirmasi Kata Sandi Baru'),
            const SizedBox(height: 6),
            _fieldPassword(
              controller: _konfirmasiController,
              hint: 'Masukkan ulang kata sandi',
              lihat: _lihatKonfirmasi,
              onToggleLihat: () =>
                  setState(() => _lihatKonfirmasi = !_lihatKonfirmasi),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Konfirmasi kata sandi tidak boleh kosong';
                }
                if (v != _sandiBaruController.text) {
                  return 'Kata sandi baru tidak cocok';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // ── Tombol Simpan ────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.buttonBackground,
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Simpan Kata Sandi Baru',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String teks) => Text(
    teks,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  );

  /// Field password dengan toggle lihat/sembunyikan
  Widget _fieldPassword({
    required TextEditingController controller,
    required String hint,
    required bool lihat,
    required VoidCallback onToggleLihat,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !lihat,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        // Ikon kunci di luar field (prefix luar)
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: Colors.grey.shade400,
          size: 20,
        ),
        // Ikon mata untuk toggle
        suffixIcon: IconButton(
          icon: Icon(
            lihat
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey.shade400,
            size: 20,
          ),
          onPressed: onToggleLihat,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: AppTheme.buttonBackground, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}