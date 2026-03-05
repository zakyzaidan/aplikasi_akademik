import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/mata_pelajaran_model.dart';

class MataPelajaranListItem extends StatelessWidget {
  final MataPelajaran mataPelajaran;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MataPelajaranListItem({
    Key? key,
    required this.mataPelajaran,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        title: Text(mataPelajaran.namaMatpel),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(onTap: onEdit, child: const Text('Edit')),
            PopupMenuItem(onTap: onDelete, child: const Text('Hapus')),
          ],
        ),
      ),
    );
  }
}
