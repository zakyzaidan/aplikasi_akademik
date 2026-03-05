import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/laporan_ujian_model.dart';

class LaporanRepository {
  final DatabaseHelper _databaseHelper;

  LaporanRepository(this._databaseHelper);

  Future<List<LaporanUjian>> getLaporanUjian() async {
    final data = await _databaseHelper.getLaporanUjian();
    return data.map((map) => LaporanUjian.fromMap(map)).toList();
  }

  Future<List<LaporanSiswaLulus>> getLaporanSiswaLulus() async {
    final data = await _databaseHelper.getLaporanSiswaLulus();
    return data.map((map) => LaporanSiswaLulus.fromMap(map)).toList();
  }

  Future<List<LaporanSiswaGagal>> getLaporanSiswaGagal() async {
    final data = await _databaseHelper.getLaporanSiswaGagal();
    return data.map((map) => LaporanSiswaGagal.fromMap(map)).toList();
  }
}
