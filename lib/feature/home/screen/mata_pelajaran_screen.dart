import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/mata_pelajaran_model.dart';
import 'package:flutter/material.dart';

class MataPelajaranScreen extends StatefulWidget {
  const MataPelajaranScreen({Key? key}) : super(key: key);

  @override
  State<MataPelajaranScreen> createState() => _MataPelajaranScreenState();
}

class _MataPelajaranScreenState extends State<MataPelajaranScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<MataPelajaran> _mataPelajaranList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMataPelajaran();
  }

  Future<void> _loadMataPelajaran() async {
    try {
      setState(() => _isLoading = true);
      final data = await _db.getAllMataPelajaran();
      setState(() {
        _mataPelajaranList = data
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

  void _showMataPelajaranDialog({MataPelajaran? mataPelajaran}) {
    final namaController = TextEditingController(
      text: mataPelajaran?.namaMatpel ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          mataPelajaran != null
              ? 'Edit Mata Pelajaran'
              : 'Tambah Mata Pelajaran',
        ),
        content: TextField(
          controller: namaController,
          decoration: const InputDecoration(
            labelText: 'Nama Mata Pelajaran',
            hintText: 'Masukkan nama mata pelajaran',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty) {
                _showSnackBar('Nama mata pelajaran harus diisi');
                return;
              }

              try {
                final newMataPelajaran = MataPelajaran(
                  idMatpel: mataPelajaran?.idMatpel,
                  namaMatpel: namaController.text,
                );

                if (mataPelajaran != null) {
                  await _db.updateMataPelajaran(newMataPelajaran.toMap());
                  _showSnackBar('Mata pelajaran berhasil diperbarui');
                } else {
                  await _db.insertMataPelajaran(newMataPelajaran.toMap());
                  _showSnackBar('Mata pelajaran berhasil ditambahkan');
                }

                Navigator.pop(context);
                _loadMataPelajaran();
              } catch (e) {
                _showSnackBar('Error: ${e.toString()}');
              }
            },
            child: Text(mataPelajaran != null ? 'Perbarui' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _deleteMataPelajaran(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Mata Pelajaran'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus mata pelajaran ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _db.deleteMataPelajaran(id);
                Navigator.pop(context);
                _showSnackBar('Mata pelajaran berhasil dihapus');
                _loadMataPelajaran();
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
        title: const Text('Mata Pelajaran'),
        backgroundColor: Colors.green[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mataPelajaranList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Belum ada data mata pelajaran'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _mataPelajaranList.length,
              itemBuilder: (context, index) {
                final mataPelajaran = _mataPelajaranList[index];
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
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${mataPelajaran.idMatpel}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text(mataPelajaran.namaMatpel),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () => _showMataPelajaranDialog(
                            mataPelajaran: mataPelajaran,
                          ),
                          child: const Text('Edit'),
                        ),
                        PopupMenuItem(
                          onTap: () =>
                              _deleteMataPelajaran(mataPelajaran.idMatpel!),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMataPelajaranDialog(),
        tooltip: 'Tambah Mata Pelajaran',
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
