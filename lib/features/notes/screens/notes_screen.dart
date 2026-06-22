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
      appBar: AppBar(title: Text(widget.collectionName)),

      floatingActionButton: FloatingActionButton(
        heroTag: 'favorites_fab',
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
    if (provider.isLoading) {
      return const AppLoadingView();
    }

    if (provider.error != null) {
      return AppErrorView(message: provider.error!);
    }

    if (provider.notes.isEmpty) {
      return const Center(child: Text('No Notes Yet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.notes.length,

      itemBuilder: (context, index) {
        final note = provider.notes[index];

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
