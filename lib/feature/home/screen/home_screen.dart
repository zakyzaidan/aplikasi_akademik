import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:aplikasi_akademik/feature/home/screen/laporan_screen.dart';
import 'package:aplikasi_akademik/feature/home/screen/mata_pelajaran_screen.dart';
import 'package:aplikasi_akademik/feature/home/screen/peserta_screen.dart';
import 'package:aplikasi_akademik/feature/home/screen/siswa_screen.dart';
import 'package:aplikasi_akademik/feature/home/screen/ujian_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Ujian> _ujianList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUjian();
  }

  Future<void> _loadUjian() async {
    try {
      setState(() => _isLoading = true);
      final ujianData = await _db.getAllUjian();
      setState(() {
        _ujianList = ujianData.map((map) => Ujian.fromMap(map)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Group ujian by date
  Map<String, List<Ujian>> _groupUjianByDate() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Sistem Informasi Akademik',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menu Management Section
            Text(
              'Kelola Data Akademik',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMenuCard(
                  context,
                  icon: Icons.person,
                  title: 'Siswa',
                  description: 'Kelola data siswa',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SiswaScreen()),
                    ).then((_) => _loadUjian());
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.book,
                  title: 'Mata Pelajaran',
                  description: 'Kelola mata pelajaran',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MataPelajaranScreen(),
                      ),
                    ).then((_) => _loadUjian());
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.assignment,
                  title: 'Ujian',
                  description: 'Kelola ujian',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UjianScreen()),
                    ).then((_) => _loadUjian());
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.grade,
                  title: 'Peserta Ujian',
                  description: 'Kelola nilai dan peserta',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PesertaScreen()),
                    ).then((_) => _loadUjian());
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Ujian Schedule Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jadwal Ujian',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RefreshButton(onPressed: _loadUjian),
              ],
            ),
            const SizedBox(height: 16),

            // Display ujian cards by date
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_ujianList.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('Belum ada ujian yang dijadwalkan'),
                  ],
                ),
              )
            else
              ..._buildUjianByDateCards(),

            const SizedBox(height: 24),

            // Reports Section
            _buildMenuCard(
              context,
              icon: Icons.assessment,
              title: 'Laporan Akademik',
              description: 'Lihat laporan ujian, kelulusan, dan gagal',
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LaporanScreen()),
                ).then((_) => _loadUjian());
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUjianByDateCards() {
    final groupedUjian = _groupUjianByDate();
    List<Widget> widgets = [];

    groupedUjian.forEach((date, ujianList) {
      // Date header
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            date,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
        ),
      );

      // Horizontal scroll list of ujian cards
      widgets.add(
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ujianList.length,
            itemBuilder: (context, index) {
              final ujian = ujianList[index];
              return _buildUjianCard(ujian);
            },
          ),
        ),
      );
    });

    return widgets;
  }

  Widget _buildUjianCard(Ujian ujian) {
    final time = DateFormat('HH:mm').format(DateTime.parse(ujian.tanggal));

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
                Icon(Icons.assignment, color: Colors.white, size: 32),
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

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class RefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RefreshButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      tooltip: 'Refresh',
    );
  }
}
