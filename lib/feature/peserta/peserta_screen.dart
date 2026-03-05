import 'package:aplikasi_akademik/core/constant/color_constant.dart';
import 'package:aplikasi_akademik/feature/peserta/provider/peserta_provider.dart';
import 'package:aplikasi_akademik/feature/peserta/widget/form_dialog.dart';
import 'package:aplikasi_akademik/feature/peserta/widget/list_item.dart';
import 'package:aplikasi_akademik/feature/siswa/provider/siswa_provider.dart';
import 'package:aplikasi_akademik/feature/ujian/provider/ujian_provider.dart';
import 'package:aplikasi_akademik/shared/widget/custom_loading.dart';
import 'package:aplikasi_akademik/shared/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PesertaScreen extends StatefulWidget {
  const PesertaScreen({super.key});

  @override
  State<PesertaScreen> createState() => _PesertaScreenState();
}

class _PesertaScreenState extends State<PesertaScreen> {
  int? _selectedUjianId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UjianProvider>().loadUjian();
      context.read<SiswaProvider>().loadSiswa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peserta Ujian'),
        backgroundColor: AppColors.pesertaColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih Ujian:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Consumer<UjianProvider>(
              builder: (context, ujianProvider, _) {
                return DropdownButtonFormField(
                  value: _selectedUjianId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pilih ujian',
                  ),
                  items: ujianProvider.ujianList
                      .map(
                        (ujian) => DropdownMenuItem(
                          value: ujian.idUjian,
                          child: Text(ujian.namaUjian),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedUjianId = value);
                    if (value != null) {
                      context.read<PesertaProvider>().loadPesertaByUjian(value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            if (_selectedUjianId != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showDeterminasiDialog(),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Determinasi\nKelulusan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showPesertaDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah\nPeserta'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<PesertaProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const CustomLoading(
                      message: 'Memuat peserta...',
                      color: AppColors.pesertaColor,
                    );
                  }

                  if (provider.pesertaList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.grade, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text('Belum ada peserta untuk ujian ini'),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: List.generate(provider.pesertaList.length, (
                      index,
                    ) {
                      final peserta = provider.pesertaList[index];
                      return PesertaListItem(
                        peserta: peserta,
                        onEdit: () => _showPesertaDialog(peserta: peserta),
                        onDelete: () => _showDeleteDialog(peserta.idPeserta!),
                      );
                    }),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPesertaDialog({var peserta}) {
    final siswaProvider = context.read<SiswaProvider>();
    context.read<UjianProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) => PesertaFormDialog(
        peserta: peserta,
        siswaList: siswaProvider.siswaList,
        selectedUjianId: _selectedUjianId,
        onSubmit: (newPeserta) async {
          final provider = context.read<PesertaProvider>();
          bool success;

          if (peserta != null) {
            success = await provider.updatePeserta(newPeserta);
            if (success && mounted) {
              CustomSnackbar.showSuccess(
                context,
                'Peserta berhasil diperbarui',
              );
            }
          } else {
            success = await provider.addPeserta(newPeserta);
            if (success && mounted) {
              CustomSnackbar.showSuccess(
                context,
                'Peserta berhasil ditambahkan',
              );
            }
          }

          if (mounted) {
            Navigator.pop(dialogContext);
            if (_selectedUjianId != null) {
              context.read<PesertaProvider>().loadPesertaByUjian(
                _selectedUjianId!,
              );
            }
          }
        },
      ),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Peserta'),
        content: const Text('Apakah Anda yakin ingin menghapus peserta ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = context.read<PesertaProvider>();
              final success = await provider.deletePeserta(id);
              if (success && mounted) {
                CustomSnackbar.showSuccess(context, 'Peserta berhasil dihapus');
              }
              if (mounted) {
                Navigator.of(context).pop();
                if (_selectedUjianId != null) {
                  context.read<PesertaProvider>().loadPesertaByUjian(
                    _selectedUjianId!,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showDeterminasiDialog() {
    final nilaiMinimalController = TextEditingController(text: '70');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Determinasi Kelulusan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan nilai minimal kelulusan untuk ujian ini:'),
            const SizedBox(height: 16),
            TextField(
              controller: nilaiMinimalController,
              decoration: const InputDecoration(
                labelText: 'Nilai Minimal',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final nilaiMinimal = double.parse(nilaiMinimalController.text);
                final provider = context.read<PesertaProvider>();
                final success = await provider.prosesDeterminasiKelulusan(
                  _selectedUjianId!,
                  nilaiMinimal,
                );
                if (success && mounted) {
                  CustomSnackbar.showSuccess(
                    context,
                    'Determinasi kelulusan berhasil diproses',
                  );
                  Navigator.pop(context);
                  context.read<PesertaProvider>().loadPesertaByUjian(
                    _selectedUjianId!,
                  );
                }
              } catch (e) {
                if (mounted) {
                  CustomSnackbar.showError(context, 'Nilai tidak valid');
                }
              }
            },
            child: const Text('Proses'),
          ),
        ],
      ),
    );
  }
}
