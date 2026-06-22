import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snapnotes/core/di/service_locator.dart';
import 'package:snapnotes/core/services/pdf_service.dart';

import '../../../data/models/note_model.dart';
import '../../../providers/note_notifier.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late final TextEditingController _titleController;

  late final TextEditingController _contentController;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note.title);

    _contentController = TextEditingController(text: widget.note.content);

    _titleController.addListener(_onChanged);

    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    final changed =
        _titleController.text != widget.note.title ||
        _contentController.text != widget.note.content;

    if (changed != _hasChanges) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  Future<void> _saveNote() async {
    final updatedNote = widget.note
      ..title = _titleController.text.trim()
      ..content = _contentController.text.trim()
      ..updatedAt = DateTime.now();

    await context.read<NoteNotifier>().updateNote(updatedNote);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note updated successfully')));

    Navigator.pop(context);
  }

  Future<void> _deleteNote() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await context.read<NoteNotifier>().deleteNote(widget.note.id);

    if (!mounted) return;

    Navigator.pop(context);
  }

  Future<void> _exportPdf() async {
    final pdfService = getIt<PdfService>();

    final file = await pdfService.generateNotePdf(
      title: _titleController.text,
      content: _contentController.text,
    );

    await OpenFilex.open(file.path);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('PDF exported successfully')));
  }

  Future<void> _shareNote() async {
    await SharePlus.instance.share(
      ShareParams(
        text: '${_titleController.text}\n\n${_contentController.text}',
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        actions: [
          IconButton(
            onPressed: _shareNote,
            icon: const Icon(Icons.share_outlined),
          ),

          IconButton(
            onPressed: _exportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
          IconButton(
            onPressed: _deleteNote,
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: _hasChanges ? _saveNote : null,
            icon: const Icon(Icons.save_outlined),
          ),

          IconButton(
            onPressed: () async {
              await context.read<NoteNotifier>().toggleFavorite(widget.note);

              setState(() {});
            },
            icon: Icon(widget.note.isFavorite ? Icons.star : Icons.star_border),
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
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TextField(
                controller: _contentController,
                expands: true,
                minLines: null,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
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
              child: FilledButton.icon(
                onPressed: _hasChanges ? _saveNote : null,
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
