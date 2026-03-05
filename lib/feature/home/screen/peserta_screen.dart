import 'package:aplikasi_akademik/data/database/database_helper.dart';
import 'package:aplikasi_akademik/data/models/peserta_ujian_model.dart';
import 'package:aplikasi_akademik/data/models/siswa_model.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:flutter/material.dart';

class PesertaScreen extends StatefulWidget {
  const PesertaScreen({Key? key}) : super(key: key);

  @override
  State<PesertaScreen> createState() => _PesertaScreenState();
}

class _PesertaScreenState extends State<PesertaScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Ujian> _ujianList = [];
  List<Siswa> _siswaList = [];
  List<Peserta> _pesertaList = [];
  Ujian? _selectedUjian;
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
      final siswaData = await _db.getAllSiswa();
      setState(() {
        _ujianList = ujianData.map((map) => Ujian.fromMap(map)).toList();
        _siswaList = siswaData.map((map) => Siswa.fromMap(map)).toList();
        _isLoading = false;
      });
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPeserta(int idUjian) async {
    try {
      final data = await _db.getPesertaByUjian(idUjian);
      setState(() {
        _pesertaList = data.map((map) => Peserta.fromMap(map)).toList();
      });
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showPesertaDialog({Peserta? peserta}) {
    final nilaiController = TextEditingController(
      text: peserta?.nilaiUjian.toString() ?? '',
    );
    String? selectedNis = peserta?.nis;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          peserta != null ? 'Edit Nilai Peserta' : 'Tambah Peserta Ujian',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedUjian == null)
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
                      items: _siswaList
                          .map(
                            (siswa) => DropdownMenuItem(
                              value: siswa.nis,
                              child: Text(siswa.nama),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        selectedNis = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nilaiController,
                      decoration: const InputDecoration(
                        labelText: 'Nilai Ujian (0-100)',
                        hintText: 'Masukkan nilai',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          if (_selectedUjian != null)
            ElevatedButton(
              onPressed: () async {
                if (selectedNis == null || nilaiController.text.isEmpty) {
                  _showSnackBar('Semua field harus diisi');
                  return;
                }

                try {
                  final nilai = double.parse(nilaiController.text);
                  if (nilai < 0 || nilai > 100) {
                    _showSnackBar('Nilai harus antara 0-100');
                    return;
                  }

                  final newPeserta = Peserta(
                    idPeserta: peserta?.idPeserta,
                    idUjian: _selectedUjian!.idUjian!,
                    nis: selectedNis!,
                    nilaiUjian: nilai,
                    statusLulus: peserta?.statusLulus ?? 'BELUM DIPROSES',
                  );

                  if (peserta != null) {
                    await _db.updatePeserta(newPeserta.toMap());
                    _showSnackBar('Peserta berhasil diperbarui');
                  } else {
                    await _db.insertPeserta(newPeserta.toMap());
                    _showSnackBar('Peserta berhasil ditambahkan');
                  }

                  Navigator.pop(context);
                  _loadPeserta(_selectedUjian!.idUjian!);
                } catch (e) {
                  _showSnackBar('Error: ${e.toString()}');
                }
              },
              child: Text(peserta != null ? 'Perbarui' : 'Tambah'),
            ),
        ],
      ),
    );
  }

  void _deletePeserta(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Peserta'),
        content: const Text('Apakah Anda yakin ingin menghapus peserta ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _db.deletePeserta(id);
                Navigator.pop(context);
                _showSnackBar('Peserta berhasil dihapus');
                if (_selectedUjian != null) {
                  _loadPeserta(_selectedUjian!.idUjian!);
                }
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
                await _db.prosesDeterminasiKelulusan(
                  _selectedUjian!.idUjian!,
                  nilaiMinimal,
                );
                Navigator.pop(context);
                _showSnackBar('Determinasi kelulusan berhasil diproses');
                _loadPeserta(_selectedUjian!.idUjian!);
              } catch (e) {
                _showSnackBar('Error: ${e.toString()}');
              }
            },
            child: const Text('Proses'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peserta Ujian'),
        backgroundColor: Colors.purple[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Pilih Ujian:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Ujian>(
                    value: _selectedUjian,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pilih ujian',
                    ),
                    items: _ujianList
                        .map(
                          (ujian) => DropdownMenuItem(
                            value: ujian,
                            child: Text(ujian.namaUjian),
                          ),
                        )
                        .toList(),
                    onChanged: (ujian) {
                      setState(() => _selectedUjian = ujian);
                      if (ujian != null) {
                        _loadPeserta(ujian.idUjian!);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedUjian != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showDeterminasiDialog,
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
                    if (_pesertaList.isEmpty)
                      Center(
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
                      )
                    else
                      ...List.generate(_pesertaList.length, (index) {
                        final peserta = _pesertaList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: peserta.statusLulus == 'LULUS'
                                  ? Colors.green
                                  : Colors.red,
                              child: Text(
                                peserta.nilaiUjian.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(peserta.namaSiswa ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NIS: ${peserta.nis}'),
                                Text(
                                  'Status: ${peserta.statusLulus}',
                                  style: TextStyle(
                                    color: peserta.statusLulus == 'LULUS'
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () =>
                                      _showPesertaDialog(peserta: peserta),
                                  child: const Text('Edit'),
                                ),
                                PopupMenuItem(
                                  onTap: () =>
                                      _deletePeserta(peserta.idPeserta!),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ],
              ),
            ),
    );
  }
}
