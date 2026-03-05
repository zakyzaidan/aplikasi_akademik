// Model Siswa
class Siswa {
  final String nis;
  final String nama;
  final String alamat;

  Siswa({required this.nis, required this.nama, required this.alamat});

  Map<String, dynamic> toMap() {
    return {'nis': nis, 'nama': nama, 'alamat': alamat};
  }

  factory Siswa.fromMap(Map<String, dynamic> map) {
    return Siswa(nis: map['nis'], nama: map['nama'], alamat: map['alamat']);
  }
}
