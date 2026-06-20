import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/scan_notifier.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanNotifier>().initializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScanNotifier>();

    if (provider.cameraController == null ||
        !provider.cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(provider.cameraController!),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    context.read<ScanNotifier>().disposeCamera();

    super.dispose();
  }
}
