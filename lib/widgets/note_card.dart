import 'package:flutter/material.dart';

import '../../../data/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NoteCard({super.key, required this.note, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,

        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),

        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
