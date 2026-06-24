import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/features/ocr/screens/ocr_result_screen.dart';
import 'package:snapnotes/features/scan/screens/image_crop_screen.dart';
import 'package:snapnotes/features/scan/widgets/scan_mode_selector.dart';
import 'package:snapnotes/features/scan/widgets/scan_overlay.dart';
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

    return provider.capturedImage != null
        ? _buildPreview(provider)
        : _buildCamera(provider);
  }

  Widget _buildPreview(ScanNotifier provider) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(provider.capturedImage!, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Retake
              FilledButton.icon(
                onPressed: () {
                  provider.retakeImage();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retake'),
              ),

              /// Crop
              FilledButton.icon(
                onPressed: () async {
                  final croppedFile = await Navigator.push<File>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ImageCropScreen(image: provider.capturedImage!),
                    ),
                  );

                  if (croppedFile == null) {
                    return;
                  }

                  provider.setCapturedImage(croppedFile);
                },
                icon: const Icon(Icons.crop),
                label: const Text('Crop'),
              ),

              /// OCR
              FilledButton.icon(
                onPressed: () async {
                  final ocrNotifier = context.read<OcrNotifier>();

                  await ocrNotifier.recognizeText(provider.capturedImage!);

                  if (!mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OcrResultScreen(
                        extractedText: ocrNotifier.extractedText,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('Use Image'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCamera(ScanNotifier provider) {
    return Stack(
      children: [
        CameraPreview(provider.cameraController!),
        const ScanOverlay(),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      const SizedBox(width: 12),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Align document within frame',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // const Text(
                      //   'Scan Document',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                    ],
                  ),

                  // const SizedBox(height: 16),
                  // Positioned(
                  //   bottom: 155,
                  //   left: 0,
                  //   right: 0,
                  //   child: Center(
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 16,
                  //         vertical: 8,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: Colors.black45,
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //       child: const Text(
                  //         'Align document within frame',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const ScanModeSelector(),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .65),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .35),
                  blurRadius: 24,
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: () async {
                    // print('clickkk');
                    final image = await provider.pickFromGallery();

                    if (image == null) return;

                    provider.setCapturedImage(image);
                  },
                ),

                _CaptureButton(
                  onTap: () async {
                    final image = await provider.captureImage();

                    if (image == null) return;

                    provider.setCapturedImage(image);
                  },
                ),

                _buildActionButton(
                  icon: Icons.flash_on_outlined,
                  label: 'Flash',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white),
          ),

          const SizedBox(height: 8),

          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   _scanNotifier.disposeCamera();

  //   super.dispose();
  // }
}

class _CaptureButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CaptureButton({required this.onTap});

  @override
  State<_CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<_CaptureButton> {
  double _scale = 1;

  Future<void> _handleTap() async {
    setState(() {
      _scale = 0.92;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    if (!mounted) return;

    setState(() {
      _scale = 1;
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF14B8A6), width: 4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x5514B8A6),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
