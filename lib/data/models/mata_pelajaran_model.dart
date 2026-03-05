// Model Mata Pelajaran
class MataPelajaran {
  final int? idMatpel;
  final String namaMatpel;

  MataPelajaran({this.idMatpel, required this.namaMatpel});

  Map<String, dynamic> toMap() {
    return {'id_matpel': idMatpel, 'nama_matpel': namaMatpel};
  }

  factory MataPelajaran.fromMap(Map<String, dynamic> map) {
    return MataPelajaran(
      idMatpel: map['id_matpel'],
      namaMatpel: map['nama_matpel'],
    );
  }
}
