import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_routes.dart';
import '../../repositories/obat_repository.dart';
import '../../models/obat_model.dart';

class _TambahObatDialog extends StatefulWidget {
  final void Function(String nama, String dosis, List<String> waktuMinum) onSimpan;

  const _TambahObatDialog({required this.onSimpan});

  @override
  State<_TambahObatDialog> createState() => _TambahObatDialogState();
}

class _TambahObatDialogState extends State<_TambahObatDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _dosisController = TextEditingController();
  List<TimeOfDay> _waktuList = [const TimeOfDay(hour: 8, minute: 0)];

  List<Map<String, String>> _historyObat = [];
  List<Map<String, String>> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _namaController.addListener(_onNamaChanged);
  }

  @override
  void dispose() {
    _namaController.removeListener(_onNamaChanged);
    _namaController.dispose();
    _dosisController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final history = await ObatRepository.getHistoryObat();
    if (mounted) setState(() => _historyObat = history);
  }

  void _onNamaChanged() {
    final query = _namaController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _suggestions = _historyObat;
        _showSuggestions = _historyObat.isNotEmpty;
      });
      return;
    }
    final filtered = _historyObat
        .where((e) => e['nama']!.toLowerCase().contains(query))
        .toList();
    setState(() {
      _suggestions = filtered;
      _showSuggestions = filtered.isNotEmpty;
    });
  }

  void _pilihSuggestion(Map<String, String> item) {
    setState(() {
      _namaController.text = item['nama']!;
      _dosisController.text = item['dosis']!;
      _showSuggestions = false;
      _namaController.selection = TextSelection.fromPosition(
        TextPosition(offset: _namaController.text.length),
      );
    });
  }

  String _formatWaktu(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pilihWaktu(int index) async {
    final pilihan = await showTimePicker(
      context: context,
      initialTime: _waktuList[index],
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
    if (pilihan != null) {
      setState(() => _waktuList[index] = pilihan);
    }
  }

  void _tambahWaktu() =>
      setState(() => _waktuList.add(const TimeOfDay(hour: 12, minute: 0)));

  void _hapusWaktu(int index) {
    if (_waktuList.length > 1) {
      setState(() => _waktuList.removeAt(index));
    }
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    final waktuMinum = _waktuList.map(_formatWaktu).toList();
    Navigator.pop(context);
    widget.onSimpan(
      _namaController.text.trim(),
      _dosisController.text.trim(),
      waktuMinum,
    );
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 20, color: Colors.black54),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _label("Nama Obat"),
              const SizedBox(height: 6),

              if (_historyObat.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _historyObat.take(6).map((item) {
                    return GestureDetector(
                      onTap: () => _pilihSuggestion(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.buttonBackground.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.buttonBackground.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.history,
                                size: 12,
                                color: AppTheme.buttonBackground),
                            const SizedBox(width: 4),
                            Text(
                              item['nama']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.buttonBackground,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _namaController,
                    textCapitalization: TextCapitalization.words,
                    onTap: () {
                      if (_historyObat.isNotEmpty) {
                        setState(() {
                          _suggestions = _historyObat;
                          _showSuggestions = true;
                        });
                      }
                    },
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama obat tidak boleh kosong'
                        : null,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Contoh: Rifampisin",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 13),
                      suffixIcon: _namaController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.close,
                            size: 16, color: Colors.grey.shade400),
                        onPressed: () {
                          _namaController.clear();
                          _dosisController.clear();
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                        BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                        BorderSide(color: Colors.grey.shade300),
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
                        borderSide:
                        const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),

                  if (_showSuggestions && _suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      constraints: const BoxConstraints(maxHeight: 180),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: Colors.grey.shade100),
                        itemBuilder: (_, i) {
                          final item = _suggestions[i];
                          return InkWell(
                            onTap: () => _pilihSuggestion(item),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.medication_outlined,
                                      size: 16,
                                      color: AppTheme.buttonBackground),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['nama']!,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          item['dosis']!,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.north_west,
                                      size: 14,
                                      color: Colors.grey.shade400),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
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

              _label("Waktu Minum"),
              const SizedBox(height: 6),

              ..._waktuList.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pilihWaktu(e.key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 13),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                            Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_rounded,
                                  size: 18,
                                  color: Colors.grey.shade500),
                              const SizedBox(width: 8),
                              Text(_formatWaktu(e.value),
                                  style:
                                  const TextStyle(fontSize: 14)),
                              const Spacer(),
                              Icon(Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_waktuList.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () => _hapusWaktu(e.key),
                      ),
                  ],
                ),
              )),

              TextButton.icon(
                onPressed: _tambahWaktu,
                icon: const Icon(Icons.add, size: 16),
                label: const Text("Tambah Waktu"),
                style: TextButton.styleFrom(
                    foregroundColor: AppTheme.buttonBackground),
              ),

              const SizedBox(height: 16),

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
                        borderRadius: BorderRadius.circular(10)),
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
        hintStyle:
        TextStyle(color: Colors.grey.shade400, fontSize: 14),
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

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {

  JadwalHariIniModel? _jadwal;
  bool _isLoading = false;

  List<ObatModel> get _obatBelumDiminum {
    final list = List<ObatModel>.from(_jadwal?.obatBerikutnya ?? []);

    int toMinutes(String waktu) {
      final parts = waktu.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    list.sort((a, b) {
      final aMin = a.waktuMinum.isNotEmpty
          ? toMinutes(a.waktuMinum.first)
          : 9999;
      final bMin = b.waktuMinum.isNotEmpty
          ? toMinutes(b.waktuMinum.first)
          : 9999;
      return aMin.compareTo(bMin);
    });

    return list;
  }
  List<ObatModel> get _obatSudahDiminum =>
      (_jadwal?.semuaObat ?? []).where((o) => o.sudahMinum).toList();
  int get _totalObat => _jadwal?.totalObat ?? 0;
  int get _obatDiminum => _jadwal?.sudahMinum ?? 0;
  double get _progress => _totalObat == 0 ? 0 : (_obatDiminum / _totalObat).clamp(0.0, 1.0);

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
    _loadJadwal();
  }

  Future<void> _loadJadwal({int retry = 3}) async {
    if (retry == 3) setState(() => _isLoading = true);
    try {
      final data = await ObatRepository.getJadwalHariIni();
      setState(() => _jadwal = data);
    } catch (e) {
      if (retry > 0) {
        await Future.delayed(const Duration(seconds: 2));
        await _loadJadwal(retry: retry - 1);
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Koneksi bermasalah. Tarik ke bawah untuk refresh.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _tandaiDiminum(ObatModel obat) async {
    try {
      await ObatRepository.konfirmasiMinum(obat.id, obat.namaObat);
      await _loadJadwal();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal konfirmasi: $e')),
        );
      }
    }
  }

  Future<void> _hapusObat(ObatModel obat) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Obat'),
        content: Text(
          'Hapus "${obat.namaObat}" dari jadwal?\n'
              'Obat ini tidak akan muncul lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ObatRepository.hapusObat(obat.id, obat.waktuMinum);
                await _loadJadwal();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal hapus: $e')),
                  );
                }
              }
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
        onSimpan: (nama, dosis, waktuMinum) async {
          try {
            await ObatRepository.tambahObat(
              namaObat: nama,
              dosis: dosis,
              waktuMinum: waktuMinum,
            );
            if (!mounted) return;
            await _loadJadwal();
          } catch (e) {
            if (mounted) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal tambah obat: $e')),
              );
            }
          }
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
            child: RefreshIndicator(
              onRefresh: _loadJadwal,
              child: ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, listPaddingTop, width * 0.05, 0),
              children: [

                _buildTanggal(width),
                SizedBox(height: height * 0.02),

                Text(
                  "Obat Berikutnya",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.04),
                ),
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
              Text(
                "Jadwal Obat",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                "Kelola jadwal minum obat Anda",
                style: TextStyle(
                    color: Colors.white70, fontSize: width * 0.032),
              ),
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
          Text(
            "Progress Hari Ini",
            style: TextStyle(fontSize: width * 0.035, color: Colors.black54),
          ),
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_obatDiminum.clamp(0, _totalObat)} / $_totalObat",
                style: TextStyle(
                    fontSize: width * 0.055, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${(_progress * 100).toInt()}%",
                    style: TextStyle(
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.buttonBackground),
                  ),
                  const Text(
                    "Selesai",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
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
        Text(
          _tanggalHariIni,
          style: TextStyle(
              fontSize: width * 0.038, fontWeight: FontWeight.w500),
        ),
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
      child: Text(
        pesan,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey.shade500, fontSize: 13, height: 1.5),
      ),
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
                Text(
                  obat.namaObat,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  obat.dosis,
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 13),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 12, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      obat.waktuMinum.join(', '), // ← multiple waktu
                      style: const TextStyle(
                          color: Colors.orange, fontSize: 12),
                    ),
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
        Text(
          "Semua Obat",
          style: TextStyle(
              fontSize: width * 0.04, fontWeight: FontWeight.bold),
        ),
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
                Text(
                  obat.namaObat,
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  obat.dosis,
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 13),
                ),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      obat.waktuMinum.join(', '), // ← multiple waktu
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12),
                    ),
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