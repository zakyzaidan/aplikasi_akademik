import 'package:aplikasi_akademik/feature/ujian/provider/ujian_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikasi_akademik/core/utils/date_formatter.dart';

class LaporanTanggalTab extends StatelessWidget {
  const LaporanTanggalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UjianProvider>(
      builder: (context, ujianProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cari Ujian Berdasarkan Tanggal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _showTanggalFilterDialog(context),
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Pilih Tanggal'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Daftar Semua Ujian',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if ((ujianProvider.ujianList).isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text('Belum ada data ujian'),
                      ],
                    ),
                  ),
                )
              else if (ujianProvider.ujianList.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (ujianProvider.ujianList).length,
                  itemBuilder: (context, index) {
                    final ujian = (ujianProvider.ujianList)[index];
                    try {
                      final dateTime = DateTime.parse(ujian.tanggal);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Icon(Icons.event, color: Colors.blue[700]),
                          title: Text(
                            ujian.namaUjian,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mata Pelajaran: ${ujian.namaMatpel ?? 'N/A'}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormatter.formatDateTime(dateTime),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } catch (e) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Icon(Icons.error, color: Colors.red[700]),
                          title: Text(ujian.namaUjian),
                          subtitle: Text(
                            'Error parsing date: ${ujian.tanggal}',
                          ),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showTanggalFilterDialog(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && context.mounted) {
      _showUjianByTanggal(context, selectedDate);
    }
  }

  void _showUjianByTanggal(BuildContext context, DateTime tanggal) async {
    final ujianProvider = context.read<UjianProvider>();
    try {
      final ujianByTanggal = await ujianProvider.getUjianByTanggal(
        DateFormatter.formatDateOnly(tanggal),
      );

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Ujian pada ${DateFormatter.formatDateOnly(tanggal)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: ujianByTanggal.isEmpty
              ? SizedBox(
                  height: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text('Tidak ada ujian pada tanggal ini'),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(ujianByTanggal.length, (index) {
                      final ujian = ujianByTanggal[index];
                      final jamText = DateFormatter.formatTimeOnly(
                        DateTime.parse(ujian.tanggal),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ujian.namaUjian,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mata Pelajaran: ${ujian.namaMatpel ?? 'N/A'}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pukul: $jamText',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                          if (index < ujianByTanggal.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                                bottom: 12,
                              ),
                              child: Divider(
                                color: Colors.grey[300],
                                height: 1,
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
