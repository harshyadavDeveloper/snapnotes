import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class ImageCropScreen extends StatefulWidget {
  const ImageCropScreen({super.key, required this.image});
  final File image;

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final CropController _cropController = CropController();

  Uint8List? _imageData;

  bool _isCropping = false;

  @override
  void initState() {
    super.initState();

    _loadImage();
  }

  Future<void> _loadImage() async {
    final bytes = await widget.image.readAsBytes();

    if (!mounted) return;

    setState(() {
      _imageData = bytes;
    });
  }

  void _cropImage() {
    setState(() {
      _isCropping = true;
    });

    _cropController.crop();
  }

  Future<void> _onCropped(CropResult result) async {
    switch (result) {
      case CropSuccess(:final croppedImage):
        final tempDir = Directory.systemTemp;

        final file = File(
          '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        await file.writeAsBytes(croppedImage);

        if (!mounted) return;

        Navigator.pop(context, file);

        break;

      case CropFailure(:final cause):
        if (!mounted) return;

        setState(() {
          _isCropping = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Crop failed: $cause')));

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Crop Document')),
      body: Column(
        children: [
          Expanded(
            child: Crop(
              image: _imageData!,
              controller: _cropController,
              onCropped: _onCropped,
              interactive: true,
              // initialSize: 0.9,
              baseColor: Colors.black,
              maskColor: Colors.black54,
              cornerDotBuilder: (size, edgeAlignment) {
                return Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isCropping ? null : _cropImage,
                icon: const Icon(Icons.crop),
                label: Text(_isCropping ? 'Cropping...' : 'Crop Image'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
