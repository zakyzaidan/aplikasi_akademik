import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:aplikasi_akademik/data/repositories/ujian_repository.dart';
import 'package:aplikasi_akademik/core/utils/date_formatter.dart';
import 'package:intl/intl.dart';

class HomeProvider extends ChangeNotifier {
  final UjianRepository _repository;

  HomeProvider(this._repository);

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

  Map<String, List<Ujian>> groupUjianByDate() {
    final Map<String, List<Ujian>> grouped = {};

    for (final ujian in _ujianList) {
      try {
        final dateTime = DateTime.parse(ujian.tanggal);
        final formattedDate = DateFormatter.formatDateOnly(dateTime);

        if (grouped.containsKey(formattedDate)) {
          grouped[formattedDate]!.add(ujian);
        } else {
          grouped[formattedDate] = [ujian];
        }
      } catch (e) {
        // Jika gagal parse tanggal, kelompokkan ke "Tanggal Tidak Valid"
        final key = 'Tanggal Tidak Valid';
        if (grouped.containsKey(key)) {
          grouped[key]!.add(ujian);
        } else {
          grouped[key] = [ujian];
        }
      }
    }

    // Urutkan berdasarkan tanggal
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        try {
          // Parse tanggal untuk sorting
          final dateA = a == 'Tanggal Tidak Valid'
              ? DateTime(2999)
              : DateFormat('dd-MM-yyyy').parse(a);
          final dateB = b == 'Tanggal Tidak Valid'
              ? DateTime(2999)
              : DateFormat('dd-MM-yyyy').parse(b);
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

    final Map<String, List<Ujian>> sortedGrouped = {};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }
}
