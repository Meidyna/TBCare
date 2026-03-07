import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';

// ════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════
class ObatModel {
  final String id;
  final String nama;
  final String dosis;
  final String jam;
  bool sudahDiminum;

  ObatModel({
    required this.id,
    required this.nama,
    required this.dosis,
    required this.jam,
    this.sudahDiminum = false,
  });

// TODO: Uncomment saat API tersedia
// factory ObatModel.fromJson(Map<String, dynamic> json) {
//   return ObatModel(
//     id: json['id'].toString(),
//     nama: json['nama'],
//     dosis: json['dosis'],
//     jam: json['jam'],
//     sudahDiminum: json['sudah_diminum'] ?? false,
//   );
// }
}

// ════════════════════════════════════════════════════════════════
// DIALOG TAMBAH OBAT
// ════════════════════════════════════════════════════════════════
class _TambahObatDialog extends StatefulWidget {
  final void Function(ObatModel) onSimpan;

  const _TambahObatDialog({required this.onSimpan});

  @override
  State<_TambahObatDialog> createState() => _TambahObatDialogState();
}

class _TambahObatDialogState extends State<_TambahObatDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _dosisController = TextEditingController();
  TimeOfDay _waktu = const TimeOfDay(hour: 8, minute: 0);

  @override
  void dispose() {
    _namaController.dispose();
    _dosisController.dispose();
    super.dispose();
  }

  String get _waktuFormatted {
    final jam = _waktu.hour.toString().padLeft(2, '0');
    final menit = _waktu.minute.toString().padLeft(2, '0');
    return '$jam:$menit';
  }

  Future<void> _pilihWaktu() async {
    final TimeOfDay? pilihan = await showTimePicker(
      context: context,
      initialTime: _waktu,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.buttonBackground,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (pilihan != null) setState(() => _waktu = pilihan);
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final obatBaru = ObatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: _namaController.text.trim(),
      dosis: _dosisController.text.trim(),
      jam: _waktuFormatted,
      sudahDiminum: false,
    );

    Navigator.pop(context);
    widget.onSimpan(obatBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.mainBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tambah Obat Baru",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close,
                        size: 20, color: Colors.black54),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _label("Nama obat"),
              const SizedBox(height: 6),
              _textField(
                controller: _namaController,
                hint: "Contoh: Rifampisin",
                capitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama obat tidak boleh kosong'
                    : null,
              ),

              const SizedBox(height: 16),

              _label("Dosis"),
              const SizedBox(height: 6),
              _textField(
                controller: _dosisController,
                hint: "Contoh: 450mg",
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Dosis tidak boleh kosong'
                    : null,
              ),

              const SizedBox(height: 16),

              _label("Waktu"),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pilihWaktu,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 18, color: Colors.grey.shade500),
                      const SizedBox(width: 8),
                      Text(_waktuFormatted,
                          style: const TextStyle(fontSize: 14)),
                      const Spacer(),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.buttonBackground,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String teks) => Text(
    teks,
    style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87),
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: capitalization,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        // ✅ fillColor putih agar kolom isian berwarna putih
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
          borderSide: const BorderSide(
              color: AppTheme.buttonBackground, width: 2),
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

// ════════════════════════════════════════════════════════════════
// JADWAL PAGE
// ════════════════════════════════════════════════════════════════
class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {

  List<ObatModel> _daftarObat = [];
  bool _isLoading = false;

  List<ObatModel> get _obatBelumDiminum =>
      _daftarObat.where((o) => !o.sudahDiminum).toList();
  List<ObatModel> get _obatSudahDiminum =>
      _daftarObat.where((o) => o.sudahDiminum).toList();
  int get _totalObat => _daftarObat.length;
  int get _obatDiminum => _obatSudahDiminum.length;
  double get _progress => _totalObat == 0 ? 0 : _obatDiminum / _totalObat;

  String get _tanggalHariIni {
    final now = DateTime.now();
    const namaHari = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const namaBulan = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei',
      'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${namaHari[now.weekday]}, ${now.day} ${namaBulan[now.month]} ${now.year}';
  }

  @override
  void initState() {
    super.initState();
    _loadObat();
  }

  Future<void> _loadObat() async {
    setState(() => _isLoading = true);
    // TODO: fetch dari API
    setState(() => _isLoading = false);
  }

  void _tandaiDiminum(ObatModel obat) {
    setState(() => obat.sudahDiminum = true);
    // TODO: await ApiService.tandaiDiminum(obat.id);
  }

  void _hapusObat(ObatModel obat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Obat'),
        content: Text(
          'Hapus "${obat.nama}" dari jadwal?\n'
              'Obat ini tidak akan muncul lagi dan harus ditambahkan ulang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _daftarObat.removeWhere((o) => o.id == obat.id));
              // TODO: await ApiService.hapusObat(obat.id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _tampilkanDialogTambahObat() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _TambahObatDialog(
        onSimpan: (obatBaru) {
          setState(() => _daftarObat.add(obatBaru));
          // TODO: await ApiService.tambahObat(obatBaru);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerContentHeight = 130.0;
    final double headerTotal = topPadding + headerContentHeight;
    final double cardTopOffset = headerTotal - 55.0;
    const double listPaddingTop = 150.0 + 20.0;

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
            top: cardTopOffset, left: 0, right: 0, bottom: 0,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, listPaddingTop, width * 0.05, 0),
              children: [
                _buildTanggal(width),
                SizedBox(height: height * 0.02),

                Text("Obat Berikutnya",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.04)),
                SizedBox(height: height * 0.015),

                if (_obatBelumDiminum.isEmpty)
                  _buildEmptyObat(
                      "Belum ada obat yang dijadwalkan.\nTekan \"+ Tambah\" untuk menambahkan.")
                else
                  ..._obatBelumDiminum.map((o) => _obatCard(width, o)),

                SizedBox(height: height * 0.03),

                _semuaObatHeader(width),
                SizedBox(height: height * 0.02),

                if (_obatSudahDiminum.isEmpty)
                  _buildEmptyObat("Belum ada obat yang diminum hari ini.")
                else
                  ..._obatSudahDiminum.map((o) => _obatSelesai(width, o)),

                SizedBox(height: height * 0.1),
              ],
            ),
          ),
          Positioned(
            top: cardTopOffset,
            left: width * 0.05,
            right: width * 0.05,
            child: _buildProgressCard(width, height),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double width, double headerTotal, double topPadding) {
    return Container(
      height: headerTotal,
      width: width,
      padding: EdgeInsets.only(
          top: topPadding + 10, left: 4, right: width * 0.05, bottom: 8),
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
              Text("Jadwal Obat",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text("Kelola jadwal minum obat Anda",
                  style: TextStyle(
                      color: Colors.white70, fontSize: width * 0.032)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.13),
              blurRadius: 18,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Progress Hari Ini",
              style:
              TextStyle(fontSize: width * 0.035, color: Colors.black54)),
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$_obatDiminum / $_totalObat",
                  style: TextStyle(
                      fontSize: width * 0.055, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${(_progress * 100).toInt()}%",
                      style: TextStyle(
                          fontSize: width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.buttonBackground)),
                  const Text("Selesai",
                      style:
                      TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ],
          ),
          SizedBox(height: height * 0.015),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: AppTheme.buttonBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTanggal(double width) {
    return Row(
      children: [
        Icon(Icons.calendar_today,
            color: AppTheme.buttonBackground, size: width * 0.05),
        SizedBox(width: width * 0.02),
        Text(_tanggalHariIni,
            style: TextStyle(
                fontSize: width * 0.038, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEmptyObat(String pesan) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(pesan,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey.shade500, fontSize: 13, height: 1.5)),
    );
  }

  Widget _obatCard(double width, ObatModel obat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xffFCE6D4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.medication, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(obat.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(obat.dosis,
                    style:
                    TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 12, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(obat.jam,
                        style: const TextStyle(
                            color: Colors.orange, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _tandaiDiminum(obat),
            icon: const Icon(Icons.check, size: 16),
            label: const Text("Minum"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.buttonBackground,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _semuaObatHeader(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Semua Obat",
            style: TextStyle(
                fontSize: width * 0.04, fontWeight: FontWeight.bold)),
        OutlinedButton.icon(
          onPressed: _tampilkanDialogTambahObat,
          icon: const Icon(Icons.add, size: 16),
          label: const Text("Tambah"),
          style: OutlinedButton.styleFrom(
            backgroundColor: AppTheme.buttonBackground,
            foregroundColor: Colors.white,
            side: const BorderSide(color: AppTheme.buttonBackground),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  Widget _obatSelesai(double width, ObatModel obat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xffE8F3EF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.buttonBackground),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.buttonBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(obat.nama,
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold)),
                Text(obat.dosis,
                    style:
                    TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(obat.jam,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _hapusObat(obat),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}