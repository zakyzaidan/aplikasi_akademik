import 'package:aplikasi_akademik/core/constant/color_constant.dart';
import 'package:aplikasi_akademik/feature/mata_pelajaran/provider/mata_pelajaran_provider.dart';
import 'package:aplikasi_akademik/feature/mata_pelajaran/widget/form_dialog.dart';
import 'package:aplikasi_akademik/feature/mata_pelajaran/widget/list_item.dart';
import 'package:aplikasi_akademik/shared/widget/custom_loading.dart';
import 'package:aplikasi_akademik/shared/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MataPelajaranScreen extends StatefulWidget {
  const MataPelajaranScreen({super.key});

  @override
  State<MataPelajaranScreen> createState() => _MataPelajaranScreenState();
}

class _MataPelajaranScreenState extends State<MataPelajaranScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MataPelajaranProvider>().loadMataPelajaran(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Pelajaran'),
        backgroundColor: AppColors.mataPelajaranColor,
      ),
      body: Consumer<MataPelajaranProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const CustomLoading(
              message: 'Memuat mata pelajaran...',
              color: AppColors.mataPelajaranColor,
            );
          }

          if (provider.errorMessage != null) {
            _showError(provider.errorMessage!);
          }

          if (provider.mataPelajaranList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Belum ada data mata pelajaran'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.mataPelajaranList.length,
            itemBuilder: (context, index) {
              final mataPelajaran = provider.mataPelajaranList[index];
              return MataPelajaranListItem(
                mataPelajaran: mataPelajaran,
                onEdit: () => _showMataPelajaranDialog(
                  context,
                  mataPelajaran: mataPelajaran,
                ),
                onDelete: () =>
                    _showDeleteDialog(context, mataPelajaran.idMatpel!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMataPelajaranDialog(context),
        tooltip: 'Tambah Mata Pelajaran',
        backgroundColor: AppColors.mataPelajaranColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showMataPelajaranDialog(BuildContext context, {var mataPelajaran}) {
    showDialog(
      context: context,
      builder: (dialogContext) => MataPelajaranFormDialog(
        mataPelajaran: mataPelajaran,
        onSubmit: (newMataPelajaran) async {
          final provider = context.read<MataPelajaranProvider>();
          bool success;

          if (mataPelajaran != null) {
            success = await provider.updateMataPelajaran(newMataPelajaran);
            if (success && mounted) {
              CustomSnackbar.showSuccess(
                context,
                'Mata pelajaran berhasil diperbarui',
              );
            }
          } else {
            success = await provider.addMataPelajaran(newMataPelajaran);
            if (success && mounted) {
              CustomSnackbar.showSuccess(
                context,
                'Mata pelajaran berhasil ditambahkan',
              );
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
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Mata Pelajaran'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus mata pelajaran ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = context.read<MataPelajaranProvider>();
                final success = await provider.deleteMataPelajaran(id);

                if (success && mounted) {
                  CustomSnackbar.showSuccess(
                    context,
                    'Mata pelajaran berhasil dihapus',
                  );
                }

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomSnackbar.showError(context, message);
    });
  }
}
