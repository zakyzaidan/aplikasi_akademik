import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/peserta_ujian_model.dart';
import 'package:aplikasi_akademik/data/models/siswa_model.dart';

class PesertaFormDialog extends StatefulWidget {
  final Peserta? peserta;
  final List<Siswa> siswaList;
  final int? selectedUjianId;
  final Function(Peserta) onSubmit;

  const PesertaFormDialog({
    Key? key,
    this.peserta,
    required this.siswaList,
    required this.selectedUjianId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<PesertaFormDialog> createState() => _PesertaFormDialogState();
}

class _PesertaFormDialogState extends State<PesertaFormDialog> {
  late TextEditingController nilaiController;
  late String? selectedNis;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nilaiController = TextEditingController(
      text: widget.peserta?.nilaiUjian.toString() ?? '',
    );
    selectedNis = widget.peserta?.nis;
  }

  @override
  void dispose() {
    nilaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.peserta != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Nilai Peserta' : 'Tambah Peserta Ujian'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.selectedUjianId == null)
                const Text('Pilih ujian terlebih dahulu')
              else
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedNis,
                      decoration: const InputDecoration(
                        labelText: 'Siswa',
                        border: OutlineInputBorder(),
                      ),
                      items: widget.siswaList
                          .map(
                            (siswa) => DropdownMenuItem(
                              value: siswa.nis,
                              child: Text(siswa.nama),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedNis = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih siswa';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nilaiController,
                      decoration: const InputDecoration(
                        labelText: 'Nilai Ujian (0-100)',
                        hintText: 'Masukkan nilai',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nilai harus diisi';
                        }
                        try {
                          final nilai = double.parse(value);
                          if (nilai < 0 || nilai > 100) {
                            return 'Nilai harus antara 0-100';
                          }
                          return null;
                        } catch (e) {
                          return 'Nilai harus berupa angka';
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        if (widget.selectedUjianId != null)
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newPeserta = Peserta(
                  idPeserta: widget.peserta?.idPeserta,
                  idUjian: widget.selectedUjianId!,
                  nis: selectedNis!,
                  nilaiUjian: double.parse(nilaiController.text),
                  statusLulus: widget.peserta?.statusLulus ?? 'BELUM DIPROSES',
                );
                widget.onSubmit(newPeserta);
              }
            },
            child: Text(isEditing ? 'Perbarui' : 'Tambah'),
          ),
      ],
    );
  }
}
