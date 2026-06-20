import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/collection_provider.dart';
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
      body: provider.collections.isEmpty
          ? const Center(child: Text('No Collections Yet'))
          : ListView.builder(
              itemCount: provider.collections.length,
              itemBuilder: (context, index) {
                final collection = provider.collections[index];

                return ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(collection.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      provider.deleteCollection(collection.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
