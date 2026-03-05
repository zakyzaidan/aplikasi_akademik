import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/laporan_ujian_model.dart';
import 'package:aplikasi_akademik/core/utils/date_formatter.dart';

class LaporanGagalTab extends StatelessWidget {
  final List<LaporanSiswaGagal> laporanSiswaGagal;

  const LaporanGagalTab({super.key, required this.laporanSiswaGagal});

  @override
  Widget build(BuildContext context) {
    if (laporanSiswaGagal.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Tidak ada siswa yang tidak lulus'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: laporanSiswaGagal.length,
      itemBuilder: (context, index) {
        final laporan = laporanSiswaGagal[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: const Icon(Icons.close, color: Colors.white),
            ),
            title: Text(laporan.nama),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NIS: ${laporan.nis}'),
                Text('Mata Pelajaran: ${laporan.namaMatpel}'),
                Text('Ujian: ${laporan.namaUjian}'),
                Text(
                  'Nilai: ${laporan.nilaiUjian}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  DateFormatter.formatDateOnly(DateTime.parse(laporan.tanggal)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
