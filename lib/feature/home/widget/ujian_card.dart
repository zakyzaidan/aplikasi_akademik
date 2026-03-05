import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:aplikasi_akademik/core/utils/date_formatter.dart';

class UjianCard extends StatelessWidget {
  final Ujian ujian;

  const UjianCard({Key? key, required this.ujian}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = DateFormatter.formatTimeOnly(DateTime.parse(ujian.tanggal));

    return Card(
      margin: const EdgeInsets.only(right: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.orange[400]!, Colors.orange[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.assignment, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  ujian.namaUjian,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ujian.namaMatpel ?? 'Mata Pelajaran',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pukul $time',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
