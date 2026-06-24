import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/features/notes/screens/note_detail_screen.dart';
import 'package:snapnotes/widgets/note_card.dart';

import '../../../providers/note_notifier.dart';
import '../../../widgets/app_error_view.dart';
import '../../../widgets/app_loading_view.dart';
import 'note_editor_screen.dart';

class NotesScreen extends StatefulWidget {
  final int collectionId;
  final String collectionName;

  const NotesScreen({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _searchController = TextEditingController();

  String _query = '';
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteNotifier>().loadNotesByCollection(widget.collectionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collectionName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: 'notes_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  NoteEditorScreen(collectionId: widget.collectionId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: _buildBody(provider),
    );
  }

  Widget _buildBody(NoteNotifier provider) {
    final filteredNotes = provider.notes.where((note) {
      if (_query.isEmpty) {
        return true;
      }

      final query = _query.toLowerCase();

      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
    if (provider.isLoading) {
      return const AppLoadingView();
    }

    if (provider.error != null) {
      return AppErrorView(message: provider.error!);
    }

    if (provider.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_alt_outlined, size: 72),

            const SizedBox(height: 16),

            Text('No notes in ${widget.collectionName}'),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        NoteEditorScreen(collectionId: widget.collectionId),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create First Note'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotes.length,

      itemBuilder: (context, index) {
        final note = filteredNotes[index];

        return NoteCard(
          note: note,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
            );
          },
          onDelete: () {
            provider.deleteNote(note.id);
          },
        );
      },
    );
  }
}
