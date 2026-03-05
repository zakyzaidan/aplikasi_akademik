import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/laporan_ujian_model.dart';

class LaporanLulusTab extends StatelessWidget {
  final List<LaporanSiswaLulus> laporanSiswaLulus;

  const LaporanLulusTab({super.key, required this.laporanSiswaLulus});

  @override
  Widget build(BuildContext context) {
    if (laporanSiswaLulus.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Belum ada data siswa'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: laporanSiswaLulus.length,
      itemBuilder: (context, index) {
        final laporan = laporanSiswaLulus[index];
        final persentaseLulus = laporan.totalUjian > 0
            ? (laporan.jumlahLulus / laporan.totalUjian * 100)
            : 0;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                '${persentaseLulus.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(laporan.nama),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NIS: ${laporan.nis}'),
                Text(
                  'Lulus: ${laporan.jumlahLulus}/${laporan.totalUjian} | Tidak Lulus: ${laporan.jumlahTidakLulus}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
