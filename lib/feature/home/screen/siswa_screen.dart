import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/siswa_model.dart';
import 'package:flutter/material.dart';

class SiswaScreen extends StatefulWidget {
  const SiswaScreen({Key? key}) : super(key: key);

  @override
  State<SiswaScreen> createState() => _SiswaScreenState();
}

class _SiswaScreenState extends State<SiswaScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Siswa> _siswaList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSiswa();
  }

  Future<void> _loadSiswa() async {
    try {
      setState(() => _isLoading = true);
      final data = await _db.getAllSiswa();
      setState(() {
        _siswaList = data.map((map) => Siswa.fromMap(map)).toList();
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

  void _showSiswaDialog({Siswa? siswa}) {
    final nisController = TextEditingController(text: siswa?.nis ?? '');
    final namaController = TextEditingController(text: siswa?.nama ?? '');
    final alamatController = TextEditingController(text: siswa?.alamat ?? '');
    final isEditing = siswa != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Siswa' : 'Tambah Siswa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nisController,
                decoration: const InputDecoration(
                  labelText: 'NIS',
                  hintText: 'Masukkan NIS',
                  border: OutlineInputBorder(),
                ),
                enabled: !isEditing,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama siswa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Masukkan alamat',
                  border: OutlineInputBorder(),
                ),
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
              if (nisController.text.isEmpty ||
                  namaController.text.isEmpty ||
                  alamatController.text.isEmpty) {
                _showSnackBar('Semua field harus diisi');
                return;
              }

              try {
                final newSiswa = Siswa(
                  nis: nisController.text,
                  nama: namaController.text,
                  alamat: alamatController.text,
                );

                if (isEditing) {
                  await _db.updateSiswa(newSiswa.toMap());
                  _showSnackBar('Siswa berhasil diperbarui');
                } else {
                  await _db.insertSiswa(newSiswa.toMap());
                  _showSnackBar('Siswa berhasil ditambahkan');
                }

                Navigator.pop(context);
                _loadSiswa();
              } catch (e) {
                _showSnackBar('Error: ${e.toString()}');
              }
            },
            child: Text(isEditing ? 'Perbarui' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _deleteSiswa(String nis) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Siswa'),
        content: const Text('Apakah Anda yakin ingin menghapus siswa ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _db.deleteSiswa(nis);
                Navigator.pop(context);
                _showSnackBar('Siswa berhasil dihapus');
                _loadSiswa();
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
        title: const Text('Data Siswa'),
        backgroundColor: Colors.blue[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _siswaList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Belum ada data siswa'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _siswaList.length,
              itemBuilder: (context, index) {
                final siswa = _siswaList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(siswa.nama[0].toUpperCase()),
                    ),
                    title: Text(siswa.nama),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NIS: ${siswa.nis}'),
                        Text('Alamat: ${siswa.alamat}'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () => _showSiswaDialog(siswa: siswa),
                          child: const Text('Edit'),
                        ),
                        PopupMenuItem(
                          onTap: () => _deleteSiswa(siswa.nis),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSiswaDialog(),
        tooltip: 'Tambah Siswa',
        child: const Icon(Icons.add),
      ),
    );
  }
}
