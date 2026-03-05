import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:aplikasi_akademik/data/models/mata_pelajaran_model.dart';
import 'package:aplikasi_akademik/core/utils/validators.dart';
import 'package:aplikasi_akademik/core/utils/date_formatter.dart';

class UjianFormDialog extends StatefulWidget {
  final Ujian? ujian;
  final List<MataPelajaran> mataPelajaranList;
  final Function(Ujian) onSubmit;

  const UjianFormDialog({
    Key? key,
    this.ujian,
    required this.mataPelajaranList,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<UjianFormDialog> createState() => _UjianFormDialogState();
}

class _UjianFormDialogState extends State<UjianFormDialog> {
  late TextEditingController namaController;
  late DateTime selectedDate;
  late int? selectedMatpelId;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.ujian?.namaUjian ?? '');
    selectedDate = widget.ujian != null
        ? DateTime.parse(widget.ujian!.tanggal)
        : DateTime.now();
    selectedMatpelId = widget.ujian?.idMatpel;
  }

  @override
  void dispose() {
    namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ujian != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Ujian' : 'Tambah Ujian'),
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, setState) => Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Ujian',
                    hintText: 'Masukkan nama ujian',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      Validators.validateNotEmpty(value, 'Nama Ujian'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedMatpelId,
                  decoration: const InputDecoration(
                    labelText: 'Mata Pelajaran',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.mataPelajaranList
                      .map(
                        (mp) => DropdownMenuItem(
                          value: mp.idMatpel,
                          child: Text(mp.namaMatpel),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedMatpelId = value);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih mata pelajaran';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Tanggal & Waktu'),
                  subtitle: Text(DateFormatter.formatDateTime(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      );
                      if (time != null) {
                        setState(() {
                          selectedDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
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
              final newUjian = Ujian(
                idUjian: widget.ujian?.idUjian,
                namaUjian: namaController.text,
                idMatpel: selectedMatpelId!,
                tanggal: selectedDate.toIso8601String(),
              );
              widget.onSubmit(newUjian);
            }
          },
          child: Text(isEditing ? 'Perbarui' : 'Tambah'),
        ),
      ],
    );
  }
}
