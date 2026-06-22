import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/note_model.dart';
import '../../../providers/note_notifier.dart';
import '../../notes/screens/note_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context.read<NoteNotifier>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Notes',
        ),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(
    NoteNotifier provider,
  ) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          provider.error!,
        ),
      );
    }

    final favorites =
        provider.favoriteNotes;

    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_border,
              size: 72,
            ),
            SizedBox(height: 16),
            Text(
              'No favorite notes yet',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the star icon on a note to add it here',
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding:
          const EdgeInsets.all(16),
      itemCount: favorites.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 12),
      itemBuilder: (
        context,
        index,
      ) {
        final NoteModel note =
            favorites[index];

        return Card(
          child: ListTile(
            leading: const Icon(
              Icons.star,
            ),

            title: Text(
              note.title,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
            ),

            subtitle: Text(
              note.content,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
            ),

            trailing: IconButton(
              icon: const Icon(
                Icons.star,
              ),
              onPressed: () async {
                await provider
                    .toggleFavorite(
                  note,
                );
              },
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NoteDetailScreen(
                    note: note,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}