import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/laporan_ujian_model.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({Key? key}) : super(key: key);

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Ujian> _ujianList = [];
  List<LaporanUjian> _laporanUjian = [];
  List<LaporanSiswaLulus> _laporanSiswaLulus = [];
  List<LaporanSiswaGagal> _laporanSiswaGagal = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  Future<void> _loadLaporan() async {
    try {
      setState(() => _isLoading = true);
      final ujianData = await _db.getAllUjian();
      final ujianLaporan = await _db.getLaporanUjian();
      final siswaLulus = await _db.getLaporanSiswaLulus();
      final siswaGagal = await _db.getLaporanSiswaGagal();

      setState(() {
        _ujianList = ujianData.map((map) => Ujian.fromMap(map)).toList();
        _laporanUjian = ujianLaporan
            .map((map) => LaporanUjian.fromMap(map))
            .toList();
        _laporanSiswaLulus = siswaLulus
            .map((map) => LaporanSiswaLulus.fromMap(map))
            .toList();
        _laporanSiswaGagal = siswaGagal
            .map((map) => LaporanSiswaGagal.fromMap(map))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laporan Akademik'),
          backgroundColor: Colors.red[700],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ujian'),
              Tab(text: 'Tanggal'),
              Tab(text: 'Lulus'),
              Tab(text: 'Gagal'),
            ],
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildLaporanUjianTab(),
                  _buildLaporanTanggalTab(),
                  _buildLaporanSiswaLulusTab(),
                  _buildLaporanSiswaGagalTab(),
                ],
              ),
      ),
    );
  }

  // Tab 1: Laporan Ujian (NAMA_UJIAN, NAMA_MATPEL, TANGGAL, JUMLAH_PESERTA)
  Widget _buildLaporanUjianTab() {
    return _laporanUjian.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Belum ada data ujian'),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _laporanUjian.length,
            itemBuilder: (context, index) {
              final laporan = _laporanUjian[index];
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
                            DateFormat(
                              'dd-MM-yyyy HH:mm',
                            ).format(DateTime.parse(laporan.tanggal)),
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

  // Tab 2: Filter Ujian berdasarkan Tanggal
  Widget _buildLaporanTanggalTab() {
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _showTanggalFilterDialog,
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
          _ujianList.isEmpty
              ? Center(
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
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ujianList.length,
                  itemBuilder: (context, index) {
                    final ujian = _ujianList[index];
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
                                DateFormat('dd-MM-yyyy HH:mm').format(dateTime),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _showUjianDetail(ujian),
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
  }

  // Tab 3: Laporan Siswa Lulus
  Widget _buildLaporanSiswaLulusTab() {
    return _laporanSiswaLulus.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Belum ada data siswa'),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _laporanSiswaLulus.length,
            itemBuilder: (context, index) {
              final laporan = _laporanSiswaLulus[index];
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

  // Tab 4: Laporan Siswa Gagal
  Widget _buildLaporanSiswaGagalTab() {
    return _laporanSiswaGagal.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Tidak ada siswa yang tidak lulus'),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _laporanSiswaGagal.length,
            itemBuilder: (context, index) {
              final laporan = _laporanSiswaGagal[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, color: Colors.white),
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
                        DateFormat(
                          'dd-MM-yyyy',
                        ).format(DateTime.parse(laporan.tanggal)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  void _showTanggalFilterDialog() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      _showUjianByTanggal(selectedDate);
    }
  }

  void _showUjianByTanggal(DateTime tanggal) async {
    try {
      final ujianByTanggal = await _db.getUjianByTanggal(
        DateFormat('yyyy-MM-dd').format(tanggal),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Ujian pada ${DateFormat('dd-MM-yyyy').format(tanggal)}',
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
                      try {
                        final ujianData = ujianByTanggal[index];
                        final namaUjian = ujianData['nama_ujian'] ?? 'N/A';
                        final namaMatpel = ujianData['nama_matpel'] ?? 'N/A';
                        final tanggalUjian = ujianData['tanggal'] ?? '';

                        String jamText = '';
                        if (tanggalUjian.isNotEmpty) {
                          try {
                            final dateTime = DateTime.parse(tanggalUjian);
                            jamText = DateFormat('HH:mm').format(dateTime);
                          } catch (e) {
                            jamText = 'Jam tidak valid';
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaUjian,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mata Pelajaran: $namaMatpel',
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
                      } catch (e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Error parsing ujian: $e',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _showUjianDetail(Ujian ujian) {
    try {
      final dateTime = DateTime.parse(ujian.tanggal);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(ujian.namaUjian),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Mata Pelajaran', ujian.namaMatpel ?? 'N/A'),
              const SizedBox(height: 12),
              _buildInfoRow(
                'Tanggal',
                DateFormat('dd-MM-yyyy').format(dateTime),
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Waktu', DateFormat('HH:mm').format(dateTime)),
            ],
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
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
