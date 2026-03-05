import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/laporan_ujian_model.dart';
import 'package:aplikasi_akademik/core/utils/date_formatter.dart';

class LaporanUjianTab extends StatelessWidget {
  final List<LaporanUjian> laporanUjian;

  const LaporanUjianTab({super.key, required this.laporanUjian});

  @override
  Widget build(BuildContext context) {
    if (laporanUjian.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Belum ada data ujian'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: laporanUjian.length,
      itemBuilder: (context, index) {
        final laporan = laporanUjian[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ExpansionTile(
            leading: Icon(Icons.assignment, color: Colors.red[700]),
            title: Text(laporan.namaUjian),
            subtitle: Text(laporan.namaMatpel),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Nama Ujian', laporan.namaUjian),
                    const SizedBox(height: 12),
                    _buildInfoRow('Mata Pelajaran', laporan.namaMatpel),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Tanggal',
                      DateFormatter.formatDateTime(
                        DateTime.parse(laporan.tanggal),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Jumlah Peserta',
                      '${laporan.jumlahPeserta} siswa',
                      valueColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }
}
