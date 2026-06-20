import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/features/notes/screens/notes_screen.dart';
import 'package:snapnotes/providers/collection_provider.dart';

import '../../../widgets/app_error_view.dart';
import '../../../widgets/app_loading_view.dart';
import '../widgets/create_collection_bottom_sheet.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionNotifier>().loadCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectionNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Collections')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const CreateCollectionBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: _buildBody(provider),
    );
  }

  Widget _buildBody(CollectionNotifier provider) {
    if (provider.isLoading) {
      return const AppLoadingView();
    }

    if (provider.error != null) {
      return AppErrorView(message: provider.error!);
    }

    if (provider.collections.isEmpty) {
      return const Center(child: Text('No Collections Yet'));
    }

    return ListView.builder(
      itemCount: provider.collections.length,
      itemBuilder: (context, index) {
        final collection = provider.collections[index];

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotesScreen(
                  collectionId: collection.id,
                  collectionName: collection.name,
                ),
              ),
            );
          },
          leading: const Icon(Icons.folder),

          title: Text(collection.name),

          subtitle: Text(
            'Created ${collection.createdAt.day}/${collection.createdAt.month}/${collection.createdAt.year}',
          ),

          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Collection'),
                    content: Text('Delete "${collection.name}"?'),
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

              if (shouldDelete == true) {
                provider.deleteCollection(collection.id);
              }
            },
          ),
        );
      },
    );
  }
}
