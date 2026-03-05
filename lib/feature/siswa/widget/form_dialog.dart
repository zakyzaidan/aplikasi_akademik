import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/siswa_model.dart';
import 'package:aplikasi_akademik/core/utils/validators.dart';

class SiswaFormDialog extends StatefulWidget {
  final Siswa? siswa;
  final Function(Siswa) onSubmit;

  const SiswaFormDialog({Key? key, this.siswa, required this.onSubmit})
    : super(key: key);

  @override
  State<SiswaFormDialog> createState() => _SiswaFormDialogState();
}

class _SiswaFormDialogState extends State<SiswaFormDialog> {
  late TextEditingController nisController;
  late TextEditingController namaController;
  late TextEditingController alamatController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nisController = TextEditingController(text: widget.siswa?.nis ?? '');
    namaController = TextEditingController(text: widget.siswa?.nama ?? '');
    alamatController = TextEditingController(text: widget.siswa?.alamat ?? '');
  }

  @override
  void dispose() {
    nisController.dispose();
    namaController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.siswa != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Siswa' : 'Tambah Siswa'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nisController,
                enabled: !isEditing,
                decoration: const InputDecoration(
                  labelText: 'NIS',
                  hintText: 'Masukkan NIS',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateNotEmpty(value, 'NIS'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama siswa',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.validateNotEmpty(value, 'Nama'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Masukkan alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.validateNotEmpty(value, 'Alamat'),
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
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final newSiswa = Siswa(
                nis: nisController.text,
                nama: namaController.text,
                alamat: alamatController.text,
              );
              widget.onSubmit(newSiswa);
            }
          },
          child: Text(isEditing ? 'Perbarui' : 'Tambah'),
        ),
      ],
    );
  }
}
