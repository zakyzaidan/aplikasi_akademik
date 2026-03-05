import 'package:flutter/material.dart';
import 'package:aplikasi_akademik/data/models/ujian_model.dart';
import 'package:aplikasi_akademik/core/utils/date_formatter.dart';

class UjianListItem extends StatelessWidget {
  final Ujian ujian;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UjianListItem({
    Key? key,
    required this.ujian,
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
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.assignment, color: Colors.orange),
          ),
        ),
        title: Text(ujian.namaUjian),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${ujian.namaMatpel}'),
            Text(DateFormatter.formatDateTime(DateTime.parse(ujian.tanggal))),
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
