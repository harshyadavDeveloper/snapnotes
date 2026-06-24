import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/collection_provider.dart';
import '../../../providers/note_notifier.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  int? _selectedCollectionId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionNotifier>().loadCollections();
    });
  }

  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty) {
      return;
    }

    if (_selectedCollectionId == null) {
      return;
    }

    await context.read<NoteNotifier>().createNote(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      collectionId: _selectedCollectionId!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note created')));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionProvider = context.watch<CollectionNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              value: _selectedCollectionId,
              decoration: const InputDecoration(
                labelText: 'Collection',
                border: OutlineInputBorder(),
              ),
              items: collectionProvider.collections
                  .map(
                    (collection) => DropdownMenuItem(
                      value: collection.id,
                      child: Text(collection.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCollectionId = value;
                });
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TextField(
                controller: _contentController,
                expands: true,
                minLines: null,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveNote,
                child: const Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
