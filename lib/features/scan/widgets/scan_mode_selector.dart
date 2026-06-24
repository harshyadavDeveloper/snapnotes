import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/scan_notifier.dart';
import '../domain/scan_mode.dart';

class ScanModeSelector extends StatelessWidget {
  const ScanModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScanNotifier>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SegmentedButton<ScanMode>(
        segments: const [
          ButtonSegment(
            value: ScanMode.document,
            label: Text('Document'),
            icon: Icon(Icons.description),
          ),
          ButtonSegment(
            value: ScanMode.receipt,
            label: Text('Receipt'),
            icon: Icon(Icons.receipt_long),
          ),
          ButtonSegment(
            value: ScanMode.photo,
            label: Text('Photo'),
            icon: Icon(Icons.image),
          ),
        ],
        selected: {provider.selectedMode},
        onSelectionChanged: (value) {
          provider.changeMode(value.first);
        },
      ),
    );
  }
}
