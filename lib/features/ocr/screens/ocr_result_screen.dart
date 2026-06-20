import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/providers/collection_provider.dart';
import '../../../providers/note_notifier.dart';

class OcrResultScreen extends StatefulWidget {
  final String extractedText;

  const OcrResultScreen({super.key, required this.extractedText});

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

  @override
  Widget build(BuildContext context) {
    final collectionProvider = context.watch<CollectionNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Review OCR Result')),

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
              value: selectedCollectionId,
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
                minLines: null,
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
