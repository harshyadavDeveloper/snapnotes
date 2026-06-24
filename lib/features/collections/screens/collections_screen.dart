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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collections',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              '${provider.collections.length} folders',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'collections_fab',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const CreateCollectionBottomSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Collection'),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 16),

            Text(
              'No Collections Yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Text(
              'Create your first collection to organize notes.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.collections.length,
      itemBuilder: (context, index) {
        final collection = provider.collections[index];

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
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
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: .08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.folder_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
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
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    collection.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Created ${collection.createdAt.day}/${collection.createdAt.month}/${collection.createdAt.year}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Text(
                        'Open Collection',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 4),

                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
