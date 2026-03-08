import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'konten_edukasi_page.dart';

class DetailArtikelPage extends StatefulWidget {
  final KontenEdukasiModel konten;

  const DetailArtikelPage({super.key, required this.konten});

  @override
  State<DetailArtikelPage> createState() => _DetailArtikelPageState();
}

class _DetailArtikelPageState extends State<DetailArtikelPage> {

  bool _isLoading = false;

  /// TODO: Ganti dengan widget.konten.isiLengkap dari API
  String get _isiArtikel {
    return _dummyIsi[widget.konten.id] ??
        'Konten artikel ini akan segera tersedia. '
            'Silakan cek kembali nanti.';
  }

  // TODO: Hapus seluruh map ini saat API tersedia
  static const Map<String, String> _dummyIsi = {
    '1': '''Tuberkulosis (TBC) adalah penyakit menular yang disebabkan oleh bakteri Mycobacterium tuberculosis. Penyakit ini terutama menyerang paru-paru, namun dapat juga menyerang organ lain.

Penyebab TBC:
• Bakteri Mycobacterium tuberculosis
• Menyebar melalui udara saat penderita batuk, bersin, atau berbicara

Cara Penularan:
• Menghirup percikan dahak (droplet) penderita TBC aktif
• Kontak erat dengan penderita dalam waktu lama
• Sistem imun lemah meningkatkan risiko tertular

Gejala Umum:
• Batuk lebih dari 2 minggu
• Batuk berdarah
• Demam dan keringat malam
• Penurunan berat badan
• Kelelahan berkepanjangan

Pencegahan:
• Vaksinasi BCG sejak bayi
• Ventilasi ruangan yang baik
• Penggunaan masker di area berisiko
• Menyelesaikan pengobatan TBC hingga tuntas''',

    '3': '''Banyak mitos yang beredar di masyarakat tentang TBC. Penting untuk memahami mana yang fakta dan mana yang mitos.

MITOS vs FAKTA:

Mitos: TBC hanya menyerang orang miskin
Fakta: TBC dapat menyerang siapa saja tanpa memandang status ekonomi

Mitos: TBC tidak bisa disembuhkan
Fakta: TBC dapat sembuh total jika pengobatan dilakukan secara teratur selama 6 bulan

Mitos: Penderita TBC harus diisolasi selamanya
Fakta: Setelah 2 minggu pengobatan, penderita umumnya sudah tidak menular

Mitos: TBC hanya menyerang paru-paru
Fakta: TBC dapat menyerang tulang, kelenjar, ginjal, dan organ lain

Mitos: Batuk darah selalu berarti TBC
Fakta: Batuk darah bisa disebabkan berbagai kondisi, perlu pemeriksaan dokter''',

    '4': '''Nutrisi yang baik sangat penting bagi pasien TBC karena membantu memperkuat sistem imun dan mempercepat pemulihan.

Nutrisi Penting untuk Pasien TBC:

1. Protein Tinggi
• Telur, ikan, daging tanpa lemak
• Kacang-kacangan dan tahu/tempe
• Membantu memperbaiki jaringan tubuh

2. Vitamin dan Mineral
• Vitamin A: Wortel, bayam, ubi
• Vitamin C: Jeruk, jambu, tomat
• Vitamin D: Ikan, telur, sinar matahari
• Zinc: Daging, biji-bijian

3. Karbohidrat Kompleks
• Nasi merah, oat, roti gandum
• Memberikan energi tahan lama

4. Lemak Sehat
• Alpukat, kacang-kacangan
• Minyak zaitun

Yang Harus Dihindari:
• Alkohol
• Rokok
• Makanan tinggi gula
• Makanan olahan berlebihan

Tips:
• Makan porsi kecil tapi sering
• Minum air putih 8-10 gelas/hari
• Hindari makanan yang mengiritasi lambung''',
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 100.0;
    final double headerTotal = topPadding + headerContentHeight;
    const double cardOverlap = 28.0;
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
          /// Dimulai dari cardTopOffset, padding atas = sisa card di bawah
          Positioned(
            top: cardTopOffset,
            left: 0, right: 0, bottom: 0,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                width * 0.05,
                0, // card langsung dari atas, overlap ke header
                width * 0.05,
                32,
              ),
              child: _buildCardUtama(width),
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
          Expanded(
            child: Text(
              widget.konten.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
                height: 2.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Satu card berisi: info judul + badge + divider + isi artikel
  Widget _buildCardUtama(double width) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Baris ikon + judul + badge ──────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.buttonBackground.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  color: AppTheme.buttonBackground,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.konten.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Badge tipe
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.buttonBackground.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.konten.tipe,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.buttonBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Divider pemisah judul & isi ──────────────────────
          Divider(color: Colors.grey.shade100, thickness: 1),

          const SizedBox(height: 12),

          // ── Isi artikel ──────────────────────────────────────
          _buildIsiArtikel(width),
        ],
      ),
    );
  }

  /// Render isi artikel dengan formatting per baris
  Widget _buildIsiArtikel(double width) {
    final paragrafList = _isiArtikel
        .split('\n')
        .map((e) => e.trim())
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragrafList.map((baris) {
        if (baris.isEmpty) return const SizedBox(height: 8);

        final bool isBullet = baris.startsWith('•');
        final bool isHeading = !isBullet &&
            !baris.startsWith(RegExp(r'[0-9]')) &&
            baris.endsWith(':');
        final bool isNumbered = baris.startsWith(RegExp(r'[0-9]+\.'));

        if (isHeading) {
          return Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 4),
            child: Text(
              baris,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          );
        } else if (isNumbered) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 2),
            child: Text(
              baris,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          );
        } else if (isBullet) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    color: AppTheme.buttonBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Expanded(
                  child: Text(
                    baris.substring(2),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              baris,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}