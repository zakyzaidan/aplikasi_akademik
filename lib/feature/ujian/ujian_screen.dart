import 'package:aplikasi_akademik/core/constant/color_constant.dart';
import 'package:aplikasi_akademik/feature/mata_pelajaran/provider/mata_pelajaran_provider.dart';
import 'package:aplikasi_akademik/feature/ujian/provider/ujian_provider.dart';
import 'package:aplikasi_akademik/feature/ujian/widget/form_dialog.dart';
import 'package:aplikasi_akademik/feature/ujian/widget/list_item.dart';
import 'package:aplikasi_akademik/shared/widget/custom_loading.dart';
import 'package:aplikasi_akademik/shared/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UjianScreen extends StatefulWidget {
  const UjianScreen({Key? key}) : super(key: key);

  @override
  State<UjianScreen> createState() => _UjianScreenState();
}

class _UjianScreenState extends State<UjianScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UjianProvider>().loadUjian();
      context.read<MataPelajaranProvider>().loadMataPelajaran();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Ujian'),
        backgroundColor: AppColors.ujianColor,
      ),
      body: Consumer<UjianProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const CustomLoading(
              message: 'Memuat ujian...',
              color: AppColors.ujianColor,
            );
          }

          if (provider.errorMessage != null) {
            _showError(provider.errorMessage!);
          }

          if (provider.ujianList.isEmpty) {
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
            itemCount: provider.ujianList.length,
            itemBuilder: (context, index) {
              final ujian = provider.ujianList[index];
              return UjianListItem(
                ujian: ujian,
                onEdit: () => _showUjianDialog(context, ujian: ujian),
                onDelete: () => _showDeleteDialog(context, ujian.idUjian!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUjianDialog(context),
        tooltip: 'Tambah Ujian',
        backgroundColor: AppColors.ujianColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUjianDialog(BuildContext context, {var ujian}) {
    final mataPelajaranProvider = context.read<MataPelajaranProvider>();

    if (mataPelajaranProvider.mataPelajaranList.isEmpty) {
      CustomSnackbar.showWarning(
        context,
        'Silakan tambah mata pelajaran terlebih dahulu',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => UjianFormDialog(
        ujian: ujian,
        mataPelajaranList: mataPelajaranProvider.mataPelajaranList,
        onSubmit: (newUjian) async {
          final provider = context.read<UjianProvider>();
          bool success;

          if (ujian != null) {
            success = await provider.updateUjian(newUjian);
            if (success && mounted) {
              CustomSnackbar.showSuccess(context, 'Ujian berhasil diperbarui');
            }
          } else {
            success = await provider.addUjian(newUjian);
            if (success && mounted) {
              CustomSnackbar.showSuccess(context, 'Ujian berhasil ditambahkan');
            }
          }

          if (mounted) {
            Navigator.pop(dialogContext);
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Ujian'),
        content: const Text('Apakah Anda yakin ingin menghapus ujian ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = context.read<UjianProvider>();
              final success = await provider.deleteUjian(id);
              if (success && mounted) {
                CustomSnackbar.showSuccess(context, 'Ujian berhasil dihapus');
              }
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomSnackbar.showError(context, message);
    });
  }
}
