import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/peserta_ujian_model.dart';

class PesertaListItem extends StatelessWidget {
  final Peserta peserta;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PesertaListItem({
    Key? key,
    required this.peserta,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: peserta.statusLulus == 'LULUS'
              ? Colors.green
              : peserta.statusLulus == 'TIDAK LULUS'
              ? Colors.red
              : Colors.grey,
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
                    : peserta.statusLulus == 'TIDAK LULUS'
                    ? Colors.red
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
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
