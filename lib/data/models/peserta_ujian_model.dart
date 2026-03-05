// Model Peserta (Nilai Ujian)
class Peserta {
  final int? idPeserta;
  final int idUjian;
  final String nis;
  final double nilaiUjian;
  final String statusLulus;
  final String? namaSiswa; // Untuk display
  final String? namaUjian; // Untuk display
  final String? namaMatpel; // Untuk display

  Peserta({
    this.idPeserta,
    required this.idUjian,
    required this.nis,
    required this.nilaiUjian,
    this.statusLulus = 'BELUM DIPROSES',
    this.namaSiswa,
    this.namaUjian,
    this.namaMatpel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_peserta': idPeserta,
      'id_ujian': idUjian,
      'nis': nis,
      'nilai_ujian': nilaiUjian,
      'status_lulus': statusLulus,
    };
  }

  factory Peserta.fromMap(Map<String, dynamic> map) {
    return Peserta(
      idPeserta: map['id_peserta'],
      idUjian: map['id_ujian'],
      nis: map['nis'],
      nilaiUjian: map['nilai_ujian'],
      statusLulus: map['status_lulus'] ?? 'BELUM DIPROSES',
      namaSiswa: map['nama'],
      namaUjian: map['nama_ujian'],
      namaMatpel: map['nama_matpel'],
    );
  }
}
