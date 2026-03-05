import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:aplikasi_akademik/data/repositories/ujian_repository.dart';
import 'package:intl/intl.dart';

class UjianProvider extends ChangeNotifier {
  final UjianRepository _repository;

  UjianProvider(this._repository);

  List<Ujian> _ujianList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Ujian> get ujianList => _ujianList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUjian() async {
    _setLoading(true);
    _clearError();
    try {
      _ujianList = await _repository.getAllUjian();
    } catch (e) {
      _setError('Error memuat ujian: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Ujian>> getUjianByTanggal(String tanggal) async {
    try {
      return await _repository.getUjianByTanggal(tanggal);
    } catch (e) {
      _setError('Error memuat ujian: ${e.toString()}');
      return [];
    }
  }

  Future<bool> addUjian(Ujian ujian) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.insertUjian(ujian);
      await loadUjian();
      return true;
    } catch (e) {
      _setError('Error menambah ujian: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateUjian(Ujian ujian) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.updateUjian(ujian);
      await loadUjian();
      return true;
    } catch (e) {
      _setError('Error mengupdate ujian: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteUjian(int id) async {
    _setLoading(true);
    _clearError();
    try {
      await _repository.deleteUjian(id);
      await loadUjian();
      return true;
    } catch (e) {
      _setError('Error menghapus ujian: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Group ujian by date
  Map<String, List<Ujian>> groupUjianByDate() {
    Map<String, List<Ujian>> groupedUjian = {};

    for (var ujian in _ujianList) {
      final dateKey = DateFormat(
        'dd-MM-yyyy',
      ).format(DateTime.parse(ujian.tanggal));
      if (!groupedUjian.containsKey(dateKey)) {
        groupedUjian[dateKey] = [];
      }
      groupedUjian[dateKey]!.add(ujian);
    }

    // Sort by date
    var sortedKeys = groupedUjian.keys.toList()
      ..sort((a, b) {
        DateTime dateA = DateFormat('dd-MM-yyyy').parse(a);
        DateTime dateB = DateFormat('dd-MM-yyyy').parse(b);
        return dateA.compareTo(dateB);
      });

    return Map.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => groupedUjian[k]!,
    );
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
