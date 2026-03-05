import 'package:aplikasi_akademik/data/repositories/laporan_ujian_repository.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/laporan_ujian_model.dart';

class LaporanProvider extends ChangeNotifier {
  final LaporanRepository _repository;

  LaporanProvider(this._repository);

  List<LaporanUjian> _laporanUjian = [];

  List<LaporanSiswaLulus> _laporanSiswaLulus = [];
  List<LaporanSiswaGagal> _laporanSiswaGagal = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<LaporanUjian> get laporanUjian => _laporanUjian;
  List<LaporanSiswaLulus> get laporanSiswaLulus => _laporanSiswaLulus;
  List<LaporanSiswaGagal> get laporanSiswaGagal => _laporanSiswaGagal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllLaporan() async {
    _setLoading(true);
    _clearError();
    try {
      _laporanUjian = await _repository.getLaporanUjian();
      _laporanSiswaLulus = await _repository.getLaporanSiswaLulus();
      _laporanSiswaGagal = await _repository.getLaporanSiswaGagal();
    } catch (e) {
      _setError('Error memuat laporan: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadLaporanUjian() async {
    _setLoading(true);
    _clearError();
    try {
      _laporanUjian = await _repository.getLaporanUjian();
    } catch (e) {
      _setError('Error memuat laporan ujian: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadLaporanSiswaLulus() async {
    _setLoading(true);
    _clearError();
    try {
      _laporanSiswaLulus = await _repository.getLaporanSiswaLulus();
    } catch (e) {
      _setError('Error memuat laporan siswa lulus: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadLaporanSiswaGagal() async {
    _setLoading(true);
    _clearError();
    try {
      _laporanSiswaGagal = await _repository.getLaporanSiswaGagal();
    } catch (e) {
      _setError('Error memuat laporan siswa gagal: ${e.toString()}');
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
