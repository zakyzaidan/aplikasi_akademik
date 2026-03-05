import 'package:aplikasi_akademik/data/repositories/laporan_ujian_repository.dart';
import 'package:aplikasi_akademik/feature/home/home_screen.dart';
import 'package:aplikasi_akademik/feature/home/provider/home_provider.dart';
import 'package:aplikasi_akademik/feature/laporan/provider/laporan_provider.dart';
import 'package:aplikasi_akademik/feature/mata_pelajaran/provider/mata_pelajaran_provider.dart';
import 'package:aplikasi_akademik/feature/peserta/provider/peserta_provider.dart';
import 'package:aplikasi_akademik/feature/siswa/provider/siswa_provider.dart';
import 'package:aplikasi_akademik/feature/ujian/provider/ujian_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikasi_akademik/config/theme/app_theme.dart';
import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/repositories/siswa_repository.dart';
import 'package:aplikasi_akademik/data/repositories/mata_pelajaran_repository.dart';
import 'package:aplikasi_akademik/data/repositories/ujian_repository.dart';
import 'package:aplikasi_akademik/data/repositories/peserta_repository.dart';

void main() {
  runApp(const AkademikApp());
}

class AkademikApp extends StatelessWidget {
  const AkademikApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Database Provider
        Provider<DatabaseHelper>(create: (_) => DatabaseHelper()),
        // Repository Providers
        ProxyProvider<DatabaseHelper, SiswaRepository>(
          update: (_, db, __) => SiswaRepository(db),
        ),
        ProxyProvider<DatabaseHelper, MataPelajaranRepository>(
          update: (_, db, __) => MataPelajaranRepository(db),
        ),
        ProxyProvider<DatabaseHelper, UjianRepository>(
          update: (_, db, __) => UjianRepository(db),
        ),
        ProxyProvider<DatabaseHelper, PesertaRepository>(
          update: (_, db, __) => PesertaRepository(db),
        ),
        ProxyProvider<DatabaseHelper, LaporanRepository>(
          update: (_, db, __) => LaporanRepository(db),
        ),
        // Feature Providers
        ChangeNotifierProxyProvider<SiswaRepository, SiswaProvider>(
          create: (context) => SiswaProvider(context.read<SiswaRepository>()),
          update: (_, repo, __) => SiswaProvider(repo),
        ),
        ChangeNotifierProxyProvider<
          MataPelajaranRepository,
          MataPelajaranProvider
        >(
          create: (context) =>
              MataPelajaranProvider(context.read<MataPelajaranRepository>()),
          update: (_, repo, __) => MataPelajaranProvider(repo),
        ),
        ChangeNotifierProxyProvider<UjianRepository, UjianProvider>(
          create: (context) => UjianProvider(context.read<UjianRepository>()),
          update: (_, repo, __) => UjianProvider(repo),
        ),
        ChangeNotifierProxyProvider<PesertaRepository, PesertaProvider>(
          create: (context) =>
              PesertaProvider(context.read<PesertaRepository>()),
          update: (_, repo, __) => PesertaProvider(repo),
        ),
        ChangeNotifierProxyProvider<LaporanRepository, LaporanProvider>(
          create: (context) =>
              LaporanProvider(context.read<LaporanRepository>()),
          update: (_, repo, __) => LaporanProvider(repo),
        ),
        ChangeNotifierProxyProvider<UjianRepository, HomeProvider>(
          create: (context) => HomeProvider(context.read<UjianRepository>()),
          update: (_, repo, __) => HomeProvider(repo),
        ),
      ],
      child: MaterialApp(
        title: 'Sistem Akademik',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
