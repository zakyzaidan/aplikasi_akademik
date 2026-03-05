import 'package:aplikasi_akademik/core/constant/color_constant.dart';
import 'package:aplikasi_akademik/feature/home/provider/home_provider.dart';
import 'package:aplikasi_akademik/feature/home/widget/menu_cart.dart';
import 'package:aplikasi_akademik/feature/home/widget/ujian_card.dart';
import 'package:aplikasi_akademik/feature/laporan/laporan_screen.dart';
import 'package:aplikasi_akademik/feature/mata_pelajaran/mata_pelajaran_screen.dart';
import 'package:aplikasi_akademik/feature/peserta/peserta_screen.dart';
import 'package:aplikasi_akademik/feature/siswa/siswa_screen.dart';
import 'package:aplikasi_akademik/feature/ujian/ujian_screen.dart';
import 'package:aplikasi_akademik/shared/widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeProvider>().loadUjian();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sistem Informasi Akademik',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
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
                MenuCard(
                  icon: Icons.person,
                  title: 'Siswa',
                  description: 'Kelola data siswa',
                  color: AppColors.siswaColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SiswaScreen()),
                    ).then((_) => context.read<HomeProvider>().loadUjian());
                  },
                ),
                MenuCard(
                  icon: Icons.book,
                  title: 'Mata Pelajaran',
                  description: 'Kelola mata pelajaran',
                  color: AppColors.mataPelajaranColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MataPelajaranScreen(),
                      ),
                    ).then((_) => context.read<HomeProvider>().loadUjian());
                  },
                ),
                MenuCard(
                  icon: Icons.assignment,
                  title: 'Ujian',
                  description: 'Kelola ujian',
                  color: AppColors.ujianColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UjianScreen()),
                    ).then((_) => context.read<HomeProvider>().loadUjian());
                  },
                ),
                MenuCard(
                  icon: Icons.grade,
                  title: 'Peserta Ujian',
                  description: 'Kelola nilai dan peserta',
                  color: AppColors.pesertaColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PesertaScreen()),
                    ).then((_) => context.read<HomeProvider>().loadUjian());
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
                IconButton(
                  onPressed: () => context.read<HomeProvider>().loadUjian(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display ujian cards by date
            Consumer<HomeProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const CustomLoading(message: 'Memuat jadwal ujian...');
                }

                if (provider.ujianList.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Belum ada ujian yang dijadwalkan'),
                      ],
                    ),
                  );
                }

                return Column(
                  children: _buildUjianByDateCards(context, provider),
                );
              },
            ),

            const SizedBox(height: 24),

            // Reports Section
            MenuCard(
              icon: Icons.assessment,
              title: 'Laporan Akademik',
              description: 'Lihat laporan ujian, kelulusan, dan gagal',
              color: AppColors.laporanColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LaporanScreen()),
                ).then((_) => context.read<HomeProvider>().loadUjian());
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUjianByDateCards(
    BuildContext context,
    HomeProvider provider,
  ) {
    final groupedUjian = provider.groupUjianByDate();
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
              color: AppColors.ujianColor,
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
              return UjianCard(ujian: ujian);
            },
          ),
        ),
      );
    });

    return widgets;
  }
}
