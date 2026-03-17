import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';
import 'hasil_skrining_page.dart';

// ════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════
class PertanyaanModel {
  final String id;
  final String pertanyaan;
  final List<String> pilihan;

  const PertanyaanModel({
    required this.id,
    required this.pertanyaan,
    required this.pilihan,
  });

// TODO: Uncomment saat API tersedia
// factory PertanyaanModel.fromJson(Map<String, dynamic> json) {
//   return PertanyaanModel(
//     id: json['id'].toString(),
//     pertanyaan: json['pertanyaan'],
//     pilihan: List<String>.from(json['pilihan']),
//   );
// }
}

// ════════════════════════════════════════════════════════════════
// SKRINING PAGE
// ════════════════════════════════════════════════════════════════
class SkriningPage extends StatefulWidget {
  const SkriningPage({super.key});

  @override
  State<SkriningPage> createState() => _SkriningPageState();
}

class _SkriningPageState extends State<SkriningPage> {

  // ── State ────────────────────────────────────────────────────
  int _indexSaat = 0;
  String? _jawabanDipilih;
  bool _isLoading = false;

  /// Menyimpan semua jawaban: { id_pertanyaan: jawaban }
  final Map<String, String> _jawaban = {};

  // ── Data pertanyaan dummy ────────────────────────────────────
  // TODO: Ganti dengan data dari API saat tersedia
  // TODO: Sesuaikan pertanyaan dengan yang dikirim teman Anda
  final List<PertanyaanModel> _pertanyaan = const [
    PertanyaanModel(
      id: '1',
      pertanyaan: 'Apakah Anda mengalami batuk selama lebih dari 2 minggu?',
      pilihan: ['Ya', 'Tidak'],
    ),
    PertanyaanModel(
      id: '2',
      pertanyaan: 'Apakah Anda mengalami batuk berdarah?',
      pilihan: ['Ya', 'Tidak'],
    ),
    PertanyaanModel(
      id: '3',
      pertanyaan: 'Apakah Anda mengalami demam yang tidak kunjung sembuh?',
      pilihan: ['Ya', 'Tidak'],
    ),
    PertanyaanModel(
      id: '4',
      pertanyaan: 'Apakah Anda mengalami penurunan berat badan tanpa sebab?',
      pilihan: ['Ya', 'Tidak'],
    ),
    PertanyaanModel(
      id: '5',
      pertanyaan: 'Apakah Anda sering berkeringat di malam hari?',
      pilihan: ['Ya', 'Tidak'],
    ),
    PertanyaanModel(
      id: '6',
      pertanyaan: 'Apakah Anda pernah kontak erat dengan penderita TBC?',
      pilihan: ['Ya', 'Tidak'],
    ),
  ];

  // ── Getters ──────────────────────────────────────────────────
  int get _totalPertanyaan => _pertanyaan.length;
  PertanyaanModel get _pertanyaanSaat => _pertanyaan[_indexSaat];
  double get _progress => (_indexSaat + 1) / _totalPertanyaan;

  // ════════════════════════════════════════════════════════════
  // FUNGSI
  // ════════════════════════════════════════════════════════════

  /// Load pertanyaan dari API
  // TODO: Uncomment dan implementasi saat API tersedia
  // Future<void> _loadPertanyaan() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     final response = await ApiService.getPertanyaanSkrining();
  //     setState(() {
  //       _pertanyaan = (response as List)
  //           .map((e) => PertanyaanModel.fromJson(e))
  //           .toList();
  //     });
  //   } catch (e) {
  //     // handle error
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  void _pilihJawaban(String jawaban) {
    setState(() => _jawabanDipilih = jawaban);
  }

  void _selanjutnya() {
    if (_jawabanDipilih == null) return;

    // Simpan jawaban
    _jawaban[_pertanyaanSaat.id] = _jawabanDipilih!;

    if (_indexSaat < _totalPertanyaan - 1) {
      // Lanjut ke pertanyaan berikutnya
      setState(() {
        _indexSaat++;
        _jawabanDipilih = null;
      });
    } else {
      // Pertanyaan terakhir — kirim dan tampilkan hasil
      _kirimHasil();
    }
  }

  /// Hitung dan kirim hasil skrining
  Future<void> _kirimHasil() async {
    setState(() => _isLoading = true);

    // TODO: Ganti dengan pemanggilan API saat tersedia:
    // try {
    //   final response = await ApiService.kirimHasilSkrining(_jawaban);
    //   final tingkatRisiko = response['tingkat_risiko']; // "tinggi"/"sedang"/"rendah"
    //   Navigator.pushReplacementNamed(
    //     context,
    //     AppRoutes.hasilSkrining,
    //     arguments: tingkatRisiko,
    //   );
    // } catch (e) {
    //   // handle error
    // } finally {
    //   setState(() => _isLoading = false);
    // }

    // Sementara hitung risiko secara lokal berdasarkan jumlah jawaban "Ya"
    // TODO: Hapus logika ini saat API tersedia
    await Future.delayed(const Duration(milliseconds: 400));
    final jumlahYa = _jawaban.values.where((v) => v == 'Ya').length;

    String tingkatRisiko;
    if (jumlahYa >= 4) {
      tingkatRisiko = 'tinggi';
    } else if (jumlahYa >= 2) {
      tingkatRisiko = 'sedang';
    } else {
      tingkatRisiko = 'rendah';
    }

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.hasilSkrining,
        arguments: tingkatRisiko,
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
    const double cardOverlap = 35.0;
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
                  width * 0.05, 0, width * 0.05, 24),
              child: Column(
                children: [
                  // Card pertanyaan mengambang
                  _buildCardPertanyaan(width),

                  const SizedBox(height: 16),

                  // Info privasi
                  _buildInfoPrivasi(width),
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
                'Skrining Mandiri',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Jawab pertanyaan berikut untuk\nmengetahui risiko Anda',
                style: TextStyle(
                    color: Colors.white70, fontSize: width * 0.030),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card utama: progress + pertanyaan + pilihan + tombol
  Widget _buildCardPertanyaan(double width) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Progress ────────────────────────────────────
          Text(
            'Pertanyaan ${_indexSaat + 1} dari $_totalPertanyaan',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              color: AppTheme.buttonBackground,
            ),
          ),

          const SizedBox(height: 24),

          // ── Teks pertanyaan ──────────────────────────────
          Text(
            _pertanyaanSaat.pertanyaan,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // ── Pilihan jawaban ──────────────────────────────
          ..._pertanyaanSaat.pilihan.map(
                (pilihan) => _buildPilihan(pilihan, width),
          ),

          const SizedBox(height: 20),

          // ── Tombol Selanjutnya ───────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _jawabanDipilih != null ? _selanjutnya : null,
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
              child: Text(
                _indexSaat == _totalPertanyaan - 1
                    ? 'Lihat Hasil'
                    : 'Selanjutnya',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Satu opsi jawaban
  Widget _buildPilihan(String pilihan, double width) {
    final dipilih = _jawabanDipilih == pilihan;
    return GestureDetector(
      onTap: () => _pilihJawaban(pilihan),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: dipilih
              ? AppTheme.buttonBackground.withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: dipilih
                ? AppTheme.buttonBackground
                : Colors.grey.shade400,
            width: dipilih ? 2 : 1,
          ),
        ),
        child: Text(
          pilihan,
          style: TextStyle(
            fontSize: 14,
            color: dipilih ? AppTheme.buttonBackground : Colors.black87,
            fontWeight:
            dipilih ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Info privasi di bawah card
  Widget _buildInfoPrivasi(double width) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF71D6F5).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF71D6F5).withOpacity(0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: Colors.blue.shade400, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Semua informasi Anda bersifat rahasia dan hanya digunakan '
                  'untuk keperluan skrining mandiri.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff115487),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}