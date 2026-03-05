import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';

class UjianRepository {
  final DatabaseHelper _databaseHelper;

  UjianRepository(this._databaseHelper);

  Future<int> insertUjian(Ujian ujian) async {
    return await _databaseHelper.insertUjian(ujian.toMap());
  }

  Future<List<Ujian>> getAllUjian() async {
    final data = await _databaseHelper.getAllUjian();
    return data.map((map) => Ujian.fromMap(map)).toList();
  }

  Future<List<Ujian>> getUjianByTanggal(String tanggal) async {
    final data = await _databaseHelper.getUjianByTanggal(tanggal);
    return data.map((map) => Ujian.fromMap(map)).toList();
  }

  Future<int> updateUjian(Ujian ujian) async {
    return await _databaseHelper.updateUjian(ujian.toMap());
  }

  Future<int> deleteUjian(int id) async {
    return await _databaseHelper.deleteUjian(id);
  }
}
