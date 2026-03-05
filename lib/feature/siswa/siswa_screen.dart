import 'package:aplikasi_akademik/core/constant/color_constant.dart';
import 'package:aplikasi_akademik/feature/siswa/provider/siswa_provider.dart';
import 'package:aplikasi_akademik/feature/siswa/widget/form_dialog.dart';
import 'package:aplikasi_akademik/feature/siswa/widget/list_item.dart';
import 'package:aplikasi_akademik/shared/widget/custom_loading.dart';
import 'package:aplikasi_akademik/shared/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SiswaScreen extends StatefulWidget {
  const SiswaScreen({Key? key}) : super(key: key);

  @override
  State<SiswaScreen> createState() => _SiswaScreenState();
}

class _SiswaScreenState extends State<SiswaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SiswaProvider>().loadSiswa());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Siswa'),
        backgroundColor: AppColors.siswaColor,
      ),
      body: Consumer<SiswaProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const CustomLoading(message: 'Memuat data siswa...');
          }

          if (provider.errorMessage != null) {
            _showError(provider.errorMessage!);
          }

          if (provider.siswaList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Belum ada data siswa'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.siswaList.length,
            itemBuilder: (context, index) {
              final siswa = provider.siswaList[index];
              return SiswaListItem(
                siswa: siswa,
                onEdit: () => _showSiswaDialog(context, siswa: siswa),
                onDelete: () => _showDeleteDialog(context, siswa.nis),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSiswaDialog(context),
        tooltip: 'Tambah Siswa',
        backgroundColor: AppColors.siswaColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSiswaDialog(BuildContext context, {var siswa}) {
    showDialog(
      context: context,
      builder: (dialogContext) => SiswaFormDialog(
        siswa: siswa,
        onSubmit: (newSiswa) async {
          final provider = context.read<SiswaProvider>();
          bool success;

          if (siswa != null) {
            success = await provider.updateSiswa(newSiswa);
            if (success && mounted) {
              CustomSnackbar.showSuccess(context, 'Siswa berhasil diperbarui');
            }
          } else {
            success = await provider.addSiswa(newSiswa);
            if (success && mounted) {
              CustomSnackbar.showSuccess(context, 'Siswa berhasil ditambahkan');
            }
          }

          if (mounted) {
            Navigator.pop(dialogContext);
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String nis) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Siswa'),
          content: const Text('Apakah Anda yakin ingin menghapus siswa ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // tutup dialog
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = context.read<SiswaProvider>();
                final success = await provider.deleteSiswa(nis);

                if (success && mounted) {
                  CustomSnackbar.showSuccess(context, 'Siswa berhasil dihapus');
                }

                if (mounted) {
                  Navigator.of(context).pop(); // tutup dialog
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
