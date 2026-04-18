class LayananKesehatanModel {
  final String id;
  final String nama;
  final String tipe;
  final String alamat;
  final String jamOperasional;
  final String telepon;
  final String? gambarUrl;

  LayananKesehatanModel({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.alamat,
    required this.jamOperasional,
    required this.telepon,
    this.gambarUrl,
  });

  factory LayananKesehatanModel.fromJson(Map<String, dynamic> json) =>
      LayananKesehatanModel(
        id: json['_id'] ?? '',
        nama: json['nama_faskes'] ?? '',
        tipe: json['jenis'] ?? '',
        alamat: json['alamat'] ?? '',
        jamOperasional: json['jam_buka'] ?? '-',
        telepon: json['no_telepon'] ?? '-',
        gambarUrl: json['gambar_url'],
      );
}