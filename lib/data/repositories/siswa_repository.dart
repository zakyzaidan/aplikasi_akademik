import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/siswa_model.dart';

class SiswaRepository {
  final DatabaseHelper _databaseHelper;

  SiswaRepository(this._databaseHelper);

  Future<int> insertSiswa(Siswa siswa) async {
    return await _databaseHelper.insertSiswa(siswa.toMap());
  }

  Future<List<Siswa>> getAllSiswa() async {
    final data = await _databaseHelper.getAllSiswa();
    return data.map((map) => Siswa.fromMap(map)).toList();
  }

  Future<Siswa?> getSiswaByNis(String nis) async {
    final data = await _databaseHelper.getSiswaByNis(nis);
    return data != null ? Siswa.fromMap(data) : null;
  }

  Future<int> updateSiswa(Siswa siswa) async {
    return await _databaseHelper.updateSiswa(siswa.toMap());
  }

  Future<int> deleteSiswa(String nis) async {
    return await _databaseHelper.deleteSiswa(nis);
  }
}
