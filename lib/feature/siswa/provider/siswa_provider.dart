import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/siswa_model.dart';
import 'package:aplikasi_akademik/data/repositories/siswa_repository.dart';

class SiswaProvider extends ChangeNotifier {
  final SiswaRepository _repository;

  SiswaProvider(this._repository);

  List<Siswa> _siswaList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Siswa> get siswaList => _siswaList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSiswa() async {
    _setLoading(true);
    _clearError();
    try {
      _siswaList = await _repository.getAllSiswa();
    } catch (e) {
      _setError('Error memuat data siswa: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addSiswa(Siswa siswa) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.insertSiswa(siswa);
      await loadSiswa();
      return true;
    } catch (e) {
      _setError('Error menambah siswa: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateSiswa(Siswa siswa) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.updateSiswa(siswa);
      await loadSiswa();
      return true;
    } catch (e) {
      _setError('Error mengupdate siswa: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteSiswa(String nis) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.deleteSiswa(nis);
      await loadSiswa();
      return true;
    } catch (e) {
      _setError('Error menghapus siswa: ${e.toString()}');
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
