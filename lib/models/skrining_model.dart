class PertanyaanModel {
  final String id;
  final String pertanyaan;
  final int urutan;

  PertanyaanModel({
    required this.id,
    required this.pertanyaan,
    required this.urutan,
  });

  factory PertanyaanModel.fromJson(Map<String, dynamic> json) => PertanyaanModel(
    id: json['_id'],
    pertanyaan: json['pertanyaan'],
    urutan: json['urutan'],
  );
}

class HasilSkriningModel {
  final String idSkrining;
  final int totalSkor;
  final String hasilRisiko;
  final List<String> rekomendasi;
  final String tanggalSkrining;

  HasilSkriningModel({
    required this.idSkrining,
    required this.totalSkor,
    required this.hasilRisiko,
    required this.rekomendasi,
    required this.tanggalSkrining,
  });

  factory HasilSkriningModel.fromJson(Map<String, dynamic> json) => HasilSkriningModel(
    idSkrining: json['id_skrining'],
    totalSkor: json['total_skor'],
    hasilRisiko: json['hasil_risiko'],
    rekomendasi: List<String>.from(json['rekomendasi']),
    tanggalSkrining: json['tanggal_skrining'],
  );
}