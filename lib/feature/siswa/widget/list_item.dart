import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/siswa_model.dart';

class SiswaListItem extends StatelessWidget {
  final Siswa siswa;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SiswaListItem({
    Key? key,
    required this.siswa,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(siswa.nama[0].toUpperCase())),
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
            PopupMenuItem(onTap: onEdit, child: const Text('Edit')),
            PopupMenuItem(onTap: onDelete, child: const Text('Hapus')),
          ],
        ),
      ),
    );
  }
}
