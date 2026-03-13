import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../core/session/user_session.dart';

// ════════════════════════════════════════════════════════════════
// EDIT PROFIL PAGE
// ════════════════════════════════════════════════════════════════
class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {

  // ── Controllers ──────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _teleponController;

  // ── State ────────────────────────────────────────────────────
  File? _fotoBaru;        // foto yang dipilih dari galeri
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Isi field dengan data yang sudah ada
    _namaController   = TextEditingController(text: UserSession.nama);
    _emailController  = TextEditingController(text: UserSession.email);
    _teleponController = TextEditingController(text: UserSession.telepon);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  // FUNGSI
  // ════════════════════════════════════════════════════════════

  /// Pilih foto dari galeri
  Future<void> _pilihFoto() async {
    final picker = ImagePicker();
    final XFile? hasil = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (hasil != null) {
      setState(() => _fotoBaru = File(hasil.path));
    }
  }

  /// Simpan perubahan profil
  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // TODO: Ganti dengan pemanggilan API:
    // try {
    //   await ApiService.updateProfil(
    //     nama: _namaController.text.trim(),
    //     email: _emailController.text.trim(),
    //     telepon: _teleponController.text.trim(),
    //     foto: _fotoBaru, // kirim sebagai multipart jika ada
    //   );
    // } catch (e) {
    //   setState(() => _isSaving = false);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Gagal menyimpan. Coba lagi.')),
    //   );
    //   return;
    // }

    // Sementara update UserSession lokal
    // TODO: Hapus simulasi ini saat API tersedia
    await Future.delayed(const Duration(milliseconds: 400));
    UserSession.simpan(
      nama: _namaController.text.trim(),
      email: _emailController.text.trim(),
      telepon: _teleponController.text.trim(),
    );

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context, true); // true = ada perubahan, ProfilPage reload
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

    const double headerContentHeight = 200.0;
    final double headerTotal = topPadding + headerContentHeight;
    const double cardOverlap = 110.0;
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
          SizedBox(width: width * 0.01),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Edit Profil",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text("Edit profil anda disini",
                  style: TextStyle(
                      color: Colors.white70, fontSize: width * 0.032)),
            ],
          )
        ],
      ),
    );
  }

  /// Card utama berisi avatar + form
  Widget _buildCardForm(double width) {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Avatar + tombol ganti foto ──────────────────
            Center(child: _buildAvatar(width)),

            SizedBox(height: width * 0.06),

            // ── Field Nama ──────────────────────────────────
            _label('Nama Lengkap'),
            const SizedBox(height: 6),
            _fieldDenganIcon(
              icon: Icons.person_outline_rounded,
              child: _textField(
                controller: _namaController,
                hint: 'Masukkan nama lengkap',
                capitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
            ),

            SizedBox(height: width * 0.04),

            // ── Field Email ─────────────────────────────────
            _label('Email'),
            const SizedBox(height: 6),
            _fieldDenganIcon(
              icon: Icons.mail_outline_rounded,
              child: _textField(
                controller: _emailController,
                hint: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
            ),

            SizedBox(height: width * 0.04),

            // ── Field Telepon ───────────────────────────────
            _label('Nomor Telepon'),
            const SizedBox(height: 6),
            _fieldDenganIcon(
              icon: Icons.phone_outlined,
              child: _textField(
                controller: _teleponController,
                hint: 'Masukkan nomor telepon',
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nomor telepon tidak boleh kosong'
                    : null,
              ),
            ),

            SizedBox(height: width * 0.06),

            // ── Tombol Batal ────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: AppTheme.mainBackground,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Batal',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 10),

            // ── Tombol Simpan ───────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.buttonBackground,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
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
                    : const Text('Simpan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Avatar dengan badge edit di pojok kanan bawah
  Widget _buildAvatar(double width) {
    return GestureDetector(
      onTap: _pilihFoto,
      child: Stack(
        children: [
          // Foto atau placeholder
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground,
              shape: BoxShape.circle,
              image: _fotoBaru != null
                  ? DecorationImage(
                image: FileImage(_fotoBaru!),
                fit: BoxFit.cover,
              )
                  : null,
              // TODO: saat API tersedia, tampilkan foto dari URL:
              // image: profilFotoUrl != null
              //     ? DecorationImage(
              //         image: NetworkImage(profilFotoUrl!),
              //         fit: BoxFit.cover,
              //       )
              //     : null,
            ),
            child: _fotoBaru == null
                ? const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 48,
            )
                : null,
          ),

          // Badge edit oranye
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Color(0xFFE8824A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Icon di luar kotak, field input di sampingnya
  Widget _fieldDenganIcon({
    required IconData icon,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon di luar, sejajar dengan tengah field
        Padding(
          padding: const EdgeInsets.only(top: 12, right: 10),
          child: Icon(icon, color: Colors.grey.shade500, size: 20),
        ),
        // Field input mengisi sisa lebar
        Expanded(child: child),
      ],
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

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
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