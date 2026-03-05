// Model Laporan Ujian
class LaporanUjian {
  final int idUjian;
  final String namaUjian;
  final String namaMatpel;
  final String tanggal;
  final int jumlahPeserta;

  LaporanUjian({
    required this.idUjian,
    required this.namaUjian,
    required this.namaMatpel,
    required this.tanggal,
    required this.jumlahPeserta,
  });

  factory LaporanUjian.fromMap(Map<String, dynamic> map) {
    return LaporanUjian(
      idUjian: map['id_ujian'],
      namaUjian: map['nama_ujian'],
      namaMatpel: map['nama_matpel'],
      tanggal: map['tanggal'],
      jumlahPeserta: map['jumlah_peserta'] ?? 0,
    );
  }
}

// Model Laporan Siswa Lulus
class LaporanSiswaLulus {
  final String nis;
  final String nama;
  final int jumlahLulus;
  final int jumlahTidakLulus;
  final int totalUjian;

  LaporanSiswaLulus({
    required this.nis,
    required this.nama,
    required this.jumlahLulus,
    required this.jumlahTidakLulus,
    required this.totalUjian,
  });

  factory LaporanSiswaLulus.fromMap(Map<String, dynamic> map) {
    return LaporanSiswaLulus(
      nis: map['nis'],
      nama: map['nama'],
      jumlahLulus: map['jumlah_lulus'] ?? 0,
      jumlahTidakLulus: map['jumlah_tidak_lulus'] ?? 0,
      totalUjian: map['total_ujian'] ?? 0,
    );
  }
}

// Model Laporan Siswa Gagal
class LaporanSiswaGagal {
  final String nis;
  final String nama;
  final String namaMatpel;
  final String namaUjian;
  final double nilaiUjian;
  final String tanggal;

  LaporanSiswaGagal({
    required this.nis,
    required this.nama,
    required this.namaMatpel,
    required this.namaUjian,
    required this.nilaiUjian,
    required this.tanggal,
  });

  factory LaporanSiswaGagal.fromMap(Map<String, dynamic> map) {
    return LaporanSiswaGagal(
      nis: map['nis'],
      nama: map['nama'],
      namaMatpel: map['nama_matpel'],
      namaUjian: map['nama_ujian'],
      nilaiUjian: map['nilai_ujian'],
      tanggal: map['tanggal'],
    );
  }
}
