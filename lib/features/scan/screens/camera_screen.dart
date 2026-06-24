import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/features/ocr/screens/ocr_result_screen.dart';
import 'package:snapnotes/features/scan/screens/image_crop_screen.dart';
import 'package:snapnotes/providers/ocr_notifier.dart';

import '../../../providers/scan_notifier.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final ScanNotifier _scanNotifier;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanNotifier = context.read<ScanNotifier>();

      _scanNotifier.initializeCamera();
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
      body: provider.capturedImage != null
          ? _buildPreview(provider)
          : _buildCamera(provider),
    );
  }

  Widget _buildPreview(ScanNotifier provider) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(provider.capturedImage!, fit: BoxFit.cover),
        ),

        Positioned(
          bottom: 30,
          left: 20,
          child: FilledButton.icon(
            onPressed: () {
              provider.retakeImage();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retake'),
          ),
        ),

        Positioned(
          bottom: 30,
          right: 20,
          child: FilledButton.icon(
            onPressed: () async {
              final ocrNotifier = context.read<OcrNotifier>();

              await ocrNotifier.recognizeText(provider.capturedImage!);

              if (!mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      OcrResultScreen(extractedText: ocrNotifier.extractedText),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Use Image'),
          ),
        ),
      ],
    );
  }

  Widget _buildCamera(ScanNotifier provider) {
    return Stack(
      children: [
        CameraPreview(provider.cameraController!),

        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              onPressed: () async {
                final image = await provider.captureImage();

                if (image == null) {
                  return;
                }

                if (!context.mounted) {
                  return;
                }

                final croppedImage = await Navigator.push<File>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageCropScreen(image: image),
                  ),
                );

                if (croppedImage == null) {
                  return;
                }

                provider.setCapturedImage(croppedImage);
              },
              child: const Icon(Icons.camera),
            ),
          ),
        ),
      ],
    );
  }

  // @override
  // void dispose() {
  //   _scanNotifier.disposeCamera();

  //   super.dispose();
  // }
}
