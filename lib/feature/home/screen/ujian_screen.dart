import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/mata_pelajaran_model.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UjianScreen extends StatefulWidget {
  const UjianScreen({Key? key}) : super(key: key);

  @override
  State<UjianScreen> createState() => _UjianScreenState();
}

class _UjianScreenState extends State<UjianScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Ujian> _ujianList = [];
  List<MataPelajaran> _mataPelajaranList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final ujianData = await _db.getAllUjian();
      final mpData = await _db.getAllMataPelajaran();
      setState(() {
        _ujianList = ujianData.map((map) => Ujian.fromMap(map)).toList();
        _mataPelajaranList = mpData
            .map((map) => MataPelajaran.fromMap(map))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showUjianDialog({Ujian? ujian}) {
    final namaController = TextEditingController(text: ujian?.namaUjian ?? '');
    DateTime selectedDate = ujian != null
        ? DateTime.parse(ujian.tanggal)
        : DateTime.now();
    int? selectedMatpelId = ujian?.idMatpel;

    if (_mataPelajaranList.isEmpty) {
      _showSnackBar('Silakan tambah mata pelajaran terlebih dahulu');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(ujian != null ? 'Edit Ujian' : 'Tambah Ujian'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Ujian',
                    hintText: 'Masukkan nama ujian',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedMatpelId,
                  decoration: const InputDecoration(
                    labelText: 'Mata Pelajaran',
                    border: OutlineInputBorder(),
                  ),
                  items: _mataPelajaranList
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
                  hint: const Text('Pilih mata pelajaran'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Tanggal'),
                  subtitle: Text(
                    DateFormat('dd-MM-yyyy HH:mm').format(selectedDate),
                  ),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (namaController.text.isEmpty || selectedMatpelId == null) {
                  _showSnackBar('Semua field harus diisi');
                  return;
                }

                try {
                  // ✅ Untuk insert baru, idUjian tidak perlu dikirim
                  final newUjian = Ujian(
                    idUjian: ujian?.idUjian, // Ini hanya digunakan saat update
                    namaUjian: namaController.text,
                    idMatpel: selectedMatpelId!,
                    tanggal: selectedDate.toIso8601String(),
                  );

                  if (ujian != null) {
                    // Update
                    await _db.updateUjian(newUjian.toMap());
                    _showSnackBar('Ujian berhasil diperbarui');
                  } else {
                    // Insert baru
                    // ✅ Tambahkan debug log
                    print('Inserting ujian: ${newUjian.toMap()}');

                    await _db.insertUjian(newUjian.toMap());
                    _showSnackBar('Ujian berhasil ditambahkan');
                  }

                  Navigator.pop(context);
                  _loadData();
                } catch (e) {
                  print('Error detail: $e');
                  _showSnackBar('Error: ${e.toString()}');
                }
              },
              child: Text(ujian != null ? 'Perbarui' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUjian(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Ujian'),
        content: const Text('Apakah Anda yakin ingin menghapus ujian ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _db.deleteUjian(id);
                Navigator.pop(context);
                _showSnackBar('Ujian berhasil dihapus');
                _loadData();
              } catch (e) {
                _showSnackBar('Error: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Ujian'),
        backgroundColor: Colors.orange[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ujianList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Belum ada data ujian'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _ujianList.length,
              itemBuilder: (context, index) {
                final ujian = _ujianList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(Icons.assignment, color: Colors.orange),
                      ),
                    ),
                    title: Text(ujian.namaUjian),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${ujian.namaMatpel}'),
                        Text(
                          DateFormat(
                            'dd-MM-yyyy HH:mm',
                          ).format(DateTime.parse(ujian.tanggal)),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () => _showUjianDialog(ujian: ujian),
                          child: const Text('Edit'),
                        ),
                        PopupMenuItem(
                          onTap: () => _deleteUjian(ujian.idUjian!),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUjianDialog(),
        tooltip: 'Tambah Ujian',
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
