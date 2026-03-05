class Ujian {
  final int? idUjian; // Bisa null saat insert baru
  final String namaUjian;
  final int idMatpel; // TIDAK boleh null (foreign key)
  final String tanggal;
  final String? namaMatpel; // Bisa null jika JOIN fail

  Ujian({
    this.idUjian,
    required this.namaUjian,
    required this.idMatpel,
    required this.tanggal,
    this.namaMatpel,
  });

  // ✅ Perbaiki toMap() - exclude id_ujian untuk insert baru
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
    // ✅ Debug: print data yang diterima
    print('Ujian.fromMap received: $map');

    return Ujian(
      idUjian: map['id_ujian'] as int?,
      namaUjian: (map['nama_ujian'] ?? '').toString(),
      idMatpel: map['id_matpel'] as int, // ❌ Akan error jika null
      tanggal: (map['tanggal'] ?? '').toString(),
      namaMatpel: map['nama_matpel'] as String?,
    );
  }
}
