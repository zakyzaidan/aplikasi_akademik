import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/mata_pelajaran_model.dart';

class MataPelajaranRepository {
  final DatabaseHelper _databaseHelper;

  MataPelajaranRepository(this._databaseHelper);

  Future<int> insertMataPelajaran(MataPelajaran mataPelajaran) async {
    return await _databaseHelper.insertMataPelajaran(mataPelajaran.toMap());
  }

  Future<List<MataPelajaran>> getAllMataPelajaran() async {
    final data = await _databaseHelper.getAllMataPelajaran();
    return data.map((map) => MataPelajaran.fromMap(map)).toList();
  }

  Future<int> updateMataPelajaran(MataPelajaran mataPelajaran) async {
    return await _databaseHelper.updateMataPelajaran(mataPelajaran.toMap());
  }

  Future<int> deleteMataPelajaran(int id) async {
    return await _databaseHelper.deleteMataPelajaran(id);
  }
}
