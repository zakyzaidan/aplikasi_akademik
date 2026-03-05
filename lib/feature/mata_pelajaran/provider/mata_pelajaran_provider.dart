import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/mata_pelajaran_model.dart';
import 'package:aplikasi_akademik/data/repositories/mata_pelajaran_repository.dart';

class MataPelajaranProvider extends ChangeNotifier {
  final MataPelajaranRepository _repository;

  MataPelajaranProvider(this._repository);

  List<MataPelajaran> _mataPelajaranList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MataPelajaran> get mataPelajaranList => _mataPelajaranList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMataPelajaran() async {
    _setLoading(true);
    _clearError();
    try {
      _mataPelajaranList = await _repository.getAllMataPelajaran();
    } catch (e) {
      _setError('Error memuat mata pelajaran: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addMataPelajaran(MataPelajaran mataPelajaran) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.insertMataPelajaran(mataPelajaran);
      await loadMataPelajaran();
      return true;
    } catch (e) {
      _setError('Error menambah mata pelajaran: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateMataPelajaran(MataPelajaran mataPelajaran) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.updateMataPelajaran(mataPelajaran);
      await loadMataPelajaran();
      return true;
    } catch (e) {
      _setError('Error mengupdate mata pelajaran: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteMataPelajaran(int id) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.deleteMataPelajaran(id);
      await loadMataPelajaran();
      return true;
    } catch (e) {
      _setError('Error menghapus mata pelajaran: ${e.toString()}');
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
