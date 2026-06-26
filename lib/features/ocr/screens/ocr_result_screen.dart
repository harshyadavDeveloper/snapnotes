import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/providers/collection_provider.dart';
import '../../../providers/note_notifier.dart';

class OcrResultScreen extends StatefulWidget {
  const OcrResultScreen({super.key, required this.extractedText});
  final String extractedText;

  @override
  State<OcrResultScreen> createState() => _OcrResultScreenState();
}

class _OcrResultScreenState extends State<OcrResultScreen> {
  late final TextEditingController _contentController;

  final TextEditingController _titleController = TextEditingController();

  int? selectedCollectionId;

  @override
  void initState() {
    super.initState();

    _contentController = TextEditingController(text: widget.extractedText);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionNotifier>().loadCollections();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  Future<void> _saveNote() async {
    if (selectedCollectionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a collection')),
      );
      return;
    }

    await context.read<NoteNotifier>().createNote(
      title: _titleController.text.trim().isEmpty
          ? 'Untitled Note'
          : _titleController.text.trim(),
      content: _contentController.text,
      collectionId: selectedCollectionId!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note saved successfully')));

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> _showSaveDialog() async {
    final collections = context.read<CollectionNotifier>().collections;

    int? selectedCollectionId;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Save as Note'),

              content: DropdownButtonFormField<int>(
                initialValue: selectedCollectionId,
                hint: const Text('Select Collection'),

                items: collections
                    .map(
                      (collection) => DropdownMenuItem(
                        value: collection.id,
                        child: Text(collection.name),
                      ),
                    )
                    .toList(),

                onChanged: (value) {
                  setState(() {
                    selectedCollectionId = value;
                  });
                },
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                FilledButton(
                  onPressed: () async {
                    if (selectedCollectionId == null) {
                      return;
                    }

                    await _saveAsNote(selectedCollectionId!);

                    if (!context.mounted) return;

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveAsNote(int collectionId) async {
    final text = _contentController.text.trim();

    if (text.isEmpty) {
      return;
    }

    String title;

    final lines = text.split('\n');

    title = lines.first.trim();

    if (title.isEmpty) {
      title = 'Scanned Note';
    }

    if (title.length > 40) {
      title = title.substring(0, 40);
    }

    await context.read<NoteNotifier>().createNote(
      title: title,
      content: text,
      collectionId: collectionId,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OCR note saved successfully')),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final collectionProvider = context.watch<CollectionNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: _showSaveDialog,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Note Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              initialValue: selectedCollectionId,
              decoration: const InputDecoration(
                labelText: 'Collection',
                border: OutlineInputBorder(),
              ),
              items: collectionProvider.collections
                  .map(
                    (collection) => DropdownMenuItem<int>(
                      value: collection.id,
                      child: Text(collection.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCollectionId = value;
                });
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TextField(
                controller: _contentController,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Extracted Text',
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
