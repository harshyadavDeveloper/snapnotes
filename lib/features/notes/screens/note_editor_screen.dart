import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/note_notifier.dart';

class NoteEditorScreen extends StatefulWidget {
  final int collectionId;

  const NoteEditorScreen({super.key, required this.collectionId});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Note')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TextField(
                controller: _contentController,
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  alignLabelWithHint: true,
                ),
              ),
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: () async {
                if (_titleController.text.trim().isEmpty ||
                    _contentController.text.trim().isEmpty) {
                  return;
                }

                await context.read<NoteNotifier>().createNote(
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                  collectionId: widget.collectionId,
                );

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
