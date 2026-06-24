import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/features/scan/widgets/scan_line.dart';

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
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: ScannerCornerPainter(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const ScanLine(),
            ],
          ),
        ),
      ),
    );
  }
}

class ScannerCornerPainter extends CustomPainter {
  final Color color;

  ScannerCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const cornerLength = 40.0;
    const strokeWidth = 5.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Top Left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);

    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top Right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Bottom Left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );

    // Bottom Right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerCornerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
