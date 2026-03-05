import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/mata_pelajaran_model.dart';
import 'package:aplikasi_akademik/core/utils/validators.dart';

class MataPelajaranFormDialog extends StatefulWidget {
  final MataPelajaran? mataPelajaran;
  final Function(MataPelajaran) onSubmit;

  const MataPelajaranFormDialog({
    super.key,
    this.mataPelajaran,
    required this.onSubmit,
  });

  @override
  State<MataPelajaranFormDialog> createState() =>
      _MataPelajaranFormDialogState();
}

class _MataPelajaranFormDialogState extends State<MataPelajaranFormDialog> {
  late TextEditingController namaController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(
      text: widget.mataPelajaran?.namaMatpel ?? '',
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.mataPelajaran != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Mata Pelajaran' : 'Tambah Mata Pelajaran'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: namaController,
          decoration: const InputDecoration(
            labelText: 'Nama Mata Pelajaran',
            hintText: 'Masukkan nama mata pelajaran',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              Validators.validateNotEmpty(value, 'Nama Mata Pelajaran'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final newMataPelajaran = MataPelajaran(
                idMatpel: widget.mataPelajaran?.idMatpel,
                namaMatpel: namaController.text,
              );
              widget.onSubmit(newMataPelajaran);
            }
          },
          child: Text(isEditing ? 'Perbarui' : 'Tambah'),
        ),
      ],
    );
  }
}
