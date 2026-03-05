import 'package:aplikasi_akademik/core/constant/color_constant.dart';
import 'package:aplikasi_akademik/feature/laporan/provider/laporan_provider.dart';
import 'package:aplikasi_akademik/feature/laporan/widget/gagal.dart';
import 'package:aplikasi_akademik/feature/laporan/widget/lulus.dart';
import 'package:aplikasi_akademik/feature/laporan/widget/tab.dart';
import 'package:aplikasi_akademik/feature/laporan/widget/tanggal_tab.dart';
import 'package:aplikasi_akademik/shared/widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<LaporanProvider>().loadAllLaporan());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laporan Akademik'),
          backgroundColor: AppColors.laporanColor,
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
        body: Consumer<LaporanProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const CustomLoading(message: 'Memuat laporan...');
            }

            return TabBarView(
              children: [
                LaporanUjianTab(laporanUjian: provider.laporanUjian),
                LaporanTanggalTab(),
                LaporanLulusTab(laporanSiswaLulus: provider.laporanSiswaLulus),
                LaporanGagalTab(laporanSiswaGagal: provider.laporanSiswaGagal),
              ],
            );
          },
        ),
      ),
    );
  }
}
