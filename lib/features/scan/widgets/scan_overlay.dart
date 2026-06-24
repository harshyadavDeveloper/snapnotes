import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/scan_notifier.dart';
import '../domain/scan_mode.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ScanNotifier>().selectedMode;

    double width = 320;
    double height = 420;

    switch (mode) {
      case ScanMode.document:
        width = 320;
        height = 420;
        break;

      case ScanMode.receipt:
        width = 240;
        height = 500;
        break;

      case ScanMode.photo:
        return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
