import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/peserta_ujian_model.dart';
import 'package:aplikasi_akademik/data/repositories/peserta_repository.dart';

class PesertaProvider extends ChangeNotifier {
  final PesertaRepository _repository;

  PesertaProvider(this._repository);

  List<Peserta> _pesertaList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Peserta> get pesertaList => _pesertaList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadPesertaByUjian(int idUjian) async {
    _setLoading(true);
    _clearError();
    try {
      _pesertaList = await _repository.getPesertaByUjian(idUjian);
    } catch (e) {
      _setError('Error memuat peserta: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addPeserta(Peserta peserta) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.insertPeserta(peserta);
      return true;
    } catch (e) {
      _setError('Error menambah peserta: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePeserta(Peserta peserta) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.updatePeserta(peserta);
      return true;
    } catch (e) {
      _setError('Error mengupdate peserta: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deletePeserta(int id) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.deletePeserta(id);
      return true;
    } catch (e) {
      _setError('Error menghapus peserta: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> prosesDeterminasiKelulusan(
    int idUjian,
    double nilaiMinimal,
  ) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.prosesDeterminasiKelulusan(idUjian, nilaiMinimal);
      return true;
    } catch (e) {
      _setError('Error proses determinasi: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
