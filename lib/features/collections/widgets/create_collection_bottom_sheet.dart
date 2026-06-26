import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/core/navigation/my_navigator.dart';

import '../../../providers/collection_provider.dart';

class CreateCollectionBottomSheet extends StatefulWidget {
  const CreateCollectionBottomSheet({super.key});

  @override
  State<CreateCollectionBottomSheet> createState() =>
      _CreateCollectionBottomSheetState();
}

class _CreateCollectionBottomSheetState
    extends State<CreateCollectionBottomSheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Create Collection'),

          const SizedBox(height: 16),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Collection Name'),
          ),

          const SizedBox(height: 16),

          FilledButton(
            onPressed: () async {
              if (_nameController.text.trim().isEmpty) {
                return;
              }

              await context.read<CollectionNotifier>().createCollection(
                _nameController.text.trim(),
              );

              if (mounted) {
                MyNavigator.pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
