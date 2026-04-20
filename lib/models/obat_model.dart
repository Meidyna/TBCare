class ObatModel {
  final String id;
  final String namaObat;
  final String dosis;
  final List<String> waktuMinum;
  bool sudahMinum;

  ObatModel({
    required this.id,
    required this.namaObat,
    required this.dosis,
    required this.waktuMinum,
    this.sudahMinum = false,
  });

  factory ObatModel.fromJson(Map<String, dynamic> json) => ObatModel(
    id: json['_id'] ?? '',
    namaObat: json['nama_obat'] ?? '',
    dosis: json['dosis'] ?? '',
    waktuMinum: List<String>.from(json['waktu_minum'] ?? []),
    sudahMinum: json['sudah_minum'] ?? false,
  );
}

class JadwalHariIniModel {
  final String tanggal;
  final int sudahMinum;
  final int totalObat;
  final int persentase;
  final List<ObatModel> obatBerikutnya;
  final List<ObatModel> semuaObat;

  JadwalHariIniModel({
    required this.tanggal,
    required this.sudahMinum,
    required this.totalObat,
    required this.persentase,
    required this.obatBerikutnya,
    required this.semuaObat,
  });

  factory JadwalHariIniModel.fromJson(Map<String, dynamic> json) {
    final progress = json['progress'];
    return JadwalHariIniModel(
      tanggal: json['tanggal'] ?? '',
      sudahMinum: progress['sudah_minum'] ?? 0,
      totalObat: progress['total_obat'] ?? 0,
      persentase: progress['persentase'] ?? 0,
      obatBerikutnya: (json['obat_berikutnya'] as List)
          .map((e) => ObatModel.fromJson(e))
          .toList(),
      semuaObat: (json['semua_obat'] as List)
          .map((e) => ObatModel.fromJson(e))
          .toList(),
    );
  }
}