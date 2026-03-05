import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/peserta_ujian_model.dart';

class PesertaRepository {
  final DatabaseHelper _databaseHelper;

  PesertaRepository(this._databaseHelper);

  Future<int> insertPeserta(Peserta peserta) async {
    return await _databaseHelper.insertPeserta(peserta.toMap());
  }

  Future<List<Peserta>> getPesertaByUjian(int idUjian) async {
    final data = await _databaseHelper.getPesertaByUjian(idUjian);
    return data.map((map) => Peserta.fromMap(map)).toList();
  }

  Future<int> updatePeserta(Peserta peserta) async {
    return await _databaseHelper.updatePeserta(peserta.toMap());
  }

  Future<int> deletePeserta(int id) async {
    return await _databaseHelper.deletePeserta(id);
  }

  Future<void> prosesDeterminasiKelulusan(
    int idUjian,
    double nilaiMinimal,
  ) async {
    return await _databaseHelper.prosesDeterminasiKelulusan(
      idUjian,
      nilaiMinimal,
    );
  }
}
