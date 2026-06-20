import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Icon(
            Icons.note_alt_outlined,
            size: 72,
          ),

          const SizedBox(height: 16),

          Text(
            'No Notes Yet',
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(height: 8),

          const Text(
            'Scan your first document\nto get started.',
            textAlign:
                TextAlign.center,
          ),
        ],
      ),
    );
  }
}