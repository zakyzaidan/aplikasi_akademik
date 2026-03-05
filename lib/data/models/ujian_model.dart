class Ujian {
  final int? idUjian;
  final String namaUjian;
  final int idMatpel;
  final String tanggal;
  final String? namaMatpel;
  Ujian({
    this.idUjian,
    required this.namaUjian,
    required this.idMatpel,
    required this.tanggal,
    this.namaMatpel,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nama_ujian': namaUjian,
      'id_matpel': idMatpel,
      'tanggal': tanggal,
    };

    // Hanya include untuk update
    if (idUjian != null) {
      map['id_ujian'] = idUjian;
    }

    return map;
  }

  factory Ujian.fromMap(Map<String, dynamic> map) {
    return Ujian(
      idUjian: map['id_ujian'] as int?,
      namaUjian: (map['nama_ujian'] ?? '').toString(),
      idMatpel: map['id_matpel'] as int,
      tanggal: (map['tanggal'] ?? '').toString(),
      namaMatpel: map['nama_matpel'] as String?,
    );
  }
}
