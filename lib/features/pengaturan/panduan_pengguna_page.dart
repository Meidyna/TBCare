import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════
class _PanduanItem {
  final String? iconAsset;  // ← tambah ini
  final IconData? icon;     // ← jadikan nullable
  final String judul;
  final List<_PanduanKonten> konten;

  const _PanduanItem({
    this.iconAsset,
    this.icon,
    required this.judul,
    required this.konten,
  });
}

class _PanduanKonten {
  final String subjudul;
  final String deskripsi;
  final List<String> langkah; // numbered list, kosong jika tidak ada

  const _PanduanKonten({
    required this.subjudul,
    required this.deskripsi,
    this.langkah = const [],
  });
}

// ════════════════════════════════════════════════════════════════
// PANDUAN PENGGUNA PAGE
// ════════════════════════════════════════════════════════════════
class PanduanPenggunaPage extends StatefulWidget {
  const PanduanPenggunaPage({super.key});

  @override
  State<PanduanPenggunaPage> createState() => _PanduanPenggunaPageState();
}

class _PanduanPenggunaPageState extends State<PanduanPenggunaPage> {

  // Index accordion yang sedang terbuka, null = semua tertutup
  int? _indexTerbuka;

  // ── Data panduan ─────────────────────────────────────────────
  static const List<_PanduanItem> _daftarPanduan = [
    _PanduanItem(
      icon: Icons.home_outlined,
      judul: 'Beranda',
      konten: [
        _PanduanKonten(
          subjudul: 'Navigasi Beranda',
          deskripsi:
          'Beranda adalah halaman utama aplikasi TB Care yang menampilkan '
              'berbagai fitur dan informasi penting. Beranda memiliki menu '
              'cepat yang dapat mengakses ke banyak fitur TBCare.',
        ),
      ],
    ),
    _PanduanItem(
      iconAsset: 'assets/icons/chatbot.png',
      judul: 'Chatbot',
      konten: [
        _PanduanKonten(
          subjudul: 'Cara Menggunakan Chatbot',
          deskripsi:
          'Chatbot adalah asisten virtual yang siap membantu Anda 24/7 '
              'untuk menjawab pertanyaan seputar TBC.',
          langkah: [
            'Klik bubble chatbot di pojok kanan bawah halaman Beranda',
            'Ketik pertanyaan Anda di kolom chat',
            'Tekan tombol kirim untuk mengirim pertanyaan',
            'Chatbot akan merespon dengan jawaban yang relevan',
            'Gunakan tombol back di pojok kiri atas untuk kembali ke Beranda',
          ],
        ),
      ],
    ),
    _PanduanItem(
      iconAsset: 'assets/icons/stethoscope.png',
      judul: 'Skrining Mandiri',
      konten: [
        _PanduanKonten(
          subjudul: 'Melakukan Skrining Mandiri',
          deskripsi:
          'Fitur ini membantu Anda menilai risiko TBC berdasarkan gejala '
              'yang dialami.',
          langkah: [
            'Klik "Skrining Mandiri" di menu cepat Beranda',
            'Baca petunjuk dengan seksama',
            'Jawab semua pertanyaan sesuai dengan kondisi Anda',
            'Lihat hasil dan rekomendasi yang diberikan',
            'Ulangi skrining jika ingin melakukan skrining kembali',
          ],
        ),
        _PanduanKonten(
          subjudul: 'Interpretasi Hasil',
          deskripsi: 'Hasil assessment memberikan indikasi awal risiko TBC:',
          langkah: [
            'Risiko Rendah: Gejala minimal, tetap waspada',
            'Risiko Sedang: Ada beberapa gejala, konsultasi ke dokter',
            'Risiko Tinggi: Segera periksakan diri ke fasilitas kesehatan',
          ],
        ),
      ],
    ),
    _PanduanItem(
      icon: Icons.calendar_today_outlined,
      judul: 'Jadwal Minum Obat',
      konten: [
        _PanduanKonten(
          subjudul: 'Mengatur Jadwal Obat',
          deskripsi:
          'Fitur ini membantu Anda mengingat waktu minum obat secara '
              'teratur.',
          langkah: [
            'Buka halaman Jadwal melalui bottom navigation atau menu cepat',
            'Klik tombol "+" untuk menambah jadwal baru',
            'Masukkan nama obat dan atur waktu minum obat',
            'Simpan Jadwal',
            'Aktifkan notifikasi pengingat',
          ],
        ),
        _PanduanKonten(
          subjudul: 'Mencatat Konsumsi Obat',
          deskripsi: 'Catat setiap kali Anda minum obat:',
          langkah: [
            'Ketika notifikasi muncul, buka aplikasi',
            'Klik tombol "Minum" pada jadwal yang sesuai',
            'Sistem akan merekam waktu konsumsi obat',
            'Pantau kepatuhan minum obat Anda pada progres harian',
          ],
        ),
      ],
    ),
    _PanduanItem(
      icon: Icons.location_on_outlined,
      judul: 'Layanan Kesehatan',
      konten: [
        _PanduanKonten(
          subjudul: 'Mencari Fasilitas Kesehatan',
          deskripsi:
          'Fitur ini membantu Anda menemukan klinik, puskesmas, dan '
              'rumah sakit yang melayani pengobatan TBC.',
          langkah: [
            'Klik "Layanan Kesehatan" di menu cepat Beranda',
            'Lihat daftar fasilitas kesehatan setempat',
            'Klik kolom pencarian jika ingin mencari layanan kesehatan tertentu',
            'Sistem akan menampilkan layanan kesehatan yang sesuai dengan pencarian',
          ],
        ),
      ],
    ),
    _PanduanItem(
      icon: Icons.menu_book_outlined,
      judul: 'Konten Edukasi',
      konten: [
        _PanduanKonten(
          subjudul: 'Mengakses Konten Edukasi',
          deskripsi:
          'Fitur ini membantu Anda melihat berbagai konten edukatif '
              'terkait TBC.',
          langkah: [
            'Buka halaman Edukasi melalui menu cepat Beranda',
            'Pilih konten yang ingin diakses',
            'Pilih Artikel jika ingin mengakses semua artikel yang tersedia',
            'Pilih Video jika ingin mengakses semua video yang tersedia',
          ],
        ),
      ],
    ),
    _PanduanItem(
      icon: Icons.notifications_outlined,
      judul: 'Notifikasi',
      konten: [
        _PanduanKonten(
          subjudul: 'Mengelola Notifikasi',
          deskripsi:
          'Fitur ini membantu Anda mengatur dan mengelola berbagai jenis '
              'notifikasi.',
          langkah: [
            'Klik ikon notifikasi di pojok kanan atas Beranda',
            'Lihat semua notifikasi yang masuk',
            'Tandai sebagai sudah dibaca',
            'Hapus notifikasi yang tidak diperlukan',
          ],
        ),
      ],
    ),
    _PanduanItem(
      icon: Icons.settings_outlined,
      judul: 'Profil & Pengaturan',
      konten: [
        _PanduanKonten(
          subjudul: 'Mengelola Profil',
          deskripsi:
          'Fitur ini membantu Anda mengelola informasi pribadi dan '
              'pengaturan akun Anda.',
          langkah: [
            'Buka halaman Profil melalui bottom navigation',
            'Lihat informasi profil Anda',
            'Klik "Edit Profil" untuk mengubah data',
            'Update foto profil, nama, email, atau nomor telepon',
            'Simpan perubahan',
          ],
        ),
        _PanduanKonten(
          subjudul: 'Mengatur Preferensi',
          deskripsi: 'Sesuaikan pengaturan aplikasi di menu Pengaturan:',
          langkah: [
            'Aktifkan/nonaktifkan berbagai jenis notifikasi',
            'Ubah kata sandi untuk keamanan akun',
            'Lihat informasi versi aplikasi',
            'Lihat cara penggunaan aplikasi',
          ],
        ),
      ],
    ),
  ];

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
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, 0, width * 0.05, 32),
              children: [

                // Card sambutan
                _buildCardSambutan(width),

                const SizedBox(height: 16),

                // Daftar accordion
                ..._daftarPanduan.asMap().entries.map(
                      (entry) => _buildAccordion(
                      width, entry.key, entry.value),
                ),
              ],
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
                'Panduan Pengguna',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pelajari cara menggunakan fitur TBCare',
                style: TextStyle(
                    color: Colors.white70, fontSize: width * 0.035),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card sambutan di atas accordion
  Widget _buildCardSambutan(double width) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/icons/target.png',
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang di TBCare',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Panduan ini akan membantu Anda memahami dan menggunakan '
                      'semua fitur aplikasi TB Care untuk mendukung perjalanan '
                      'pengobatan TBC. Klik pada setiap bagian untuk melihat '
                      'detail panduan.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Satu item accordion
  Widget _buildAccordion(double width, int index, _PanduanItem item) {
    final terbuka = _indexTerbuka == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: terbuka
              ? AppTheme.buttonBackground.withOpacity(0.4)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [

          // ── Header accordion (selalu terlihat) ────────────
          InkWell(
            onTap: () => setState(() {
              _indexTerbuka = terbuka ? null : index;
            }),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Ikon fitur
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: terbuka
                          ? AppTheme.buttonBackground.withOpacity(0.12)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: item.iconAsset != null
                      ? Padding(padding: const EdgeInsets.all(8),
                    child: Image.asset(item.iconAsset!,
                    width: 20,
                    height: 20,
                    color: terbuka
                      ? AppTheme.buttonBackground
                      : Colors.grey.shade500,),
                    )
                        : Icon(
                      item.icon,
                      color: terbuka
                          ? AppTheme.buttonBackground
                          : Colors.grey.shade500,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Judul
                  Expanded(
                    child: Text(
                      item.judul,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: terbuka
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: terbuka
                            ? Colors.black87
                            : Colors.black87,
                      ),
                    ),
                  ),
                  // Panah
                  AnimatedRotation(
                    turns: terbuka ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: terbuka
                          ? AppTheme.buttonBackground
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Isi accordion (hanya saat terbuka) ───────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: terbuka
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(
                    height: 1,
                    color: Colors.grey.shade300),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: item.konten.asMap().entries.map((entry) {
                      final isLast = entry.key == item.konten.length - 1;
                      return _buildKonten(entry.value, isLast);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Satu blok konten di dalam accordion
  Widget _buildKonten(_PanduanKonten konten, bool isLast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subjudul hijau
        Text(
          konten.subjudul,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.buttonBackground,
          ),
        ),
        const SizedBox(height: 6),
        // Deskripsi
        Text(
          konten.deskripsi,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        // Numbered list langkah (jika ada)
        if (konten.langkah.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...konten.langkah.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${e.key + 1}. ',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.buttonBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
        // Pemisah antar konten dalam satu accordion
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade400),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}