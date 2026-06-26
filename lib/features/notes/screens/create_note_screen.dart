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
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionNotifier>().loadCollections();
    });

    _contentController.addListener(_updateWordCount);
  }

  void _updateWordCount() {
    setState(() {
      _wordCount = _contentController.text
          .trim()
          .split(RegExp(r'\s+'))
          .where((e) => e.isNotEmpty)
          .length;
    });
  }

  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    if (_selectedCollectionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a collection')),
      );
      return;
    }

    await context.read<NoteNotifier>().createNote(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      collectionId: _selectedCollectionId!,
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  String get _formattedDate {
    final now = DateTime.now();

    return '${now.day}/${now.month}/${now.year}';
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
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: const Text('New Note'),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: _saveNote,
              icon: const Icon(Icons.check),
              label: const Text('Save'),
            ),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: .04),

              Colors.transparent,
            ],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Collection Picker
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: .08),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedCollectionId,
                      isExpanded: true,
                      hint: const Text('Select Collection'),
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
                  ),
                ),

                const SizedBox(height: 20),

                /// Title
                TextField(
                  controller: _titleController,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Untitled Note',
                    border: InputBorder.none,
                  ),
                ),

                /// Metadata
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        'Created $_formattedDate',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                const Divider(height: 32),

                /// Content
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    expands: true,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Start writing your note...',
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Footer
                Row(
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      '$_wordCount words',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const Spacer(),

                    Text(
                      '${_contentController.text.length} characters',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
