import 'dart:io';

import 'package:camera/camera.dart';

import '../core/state/base_notifier.dart';

class ScanNotifier extends BaseNotifier {
  CameraController? cameraController;

  List<CameraDescription> cameras = [];

  File? capturedImage;

  Future<void> initializeCamera() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      return;
    }

    await execute(() async {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();

      notifyListeners();
    });
  }

  Future<void> captureImage() async {
    if (cameraController == null) return;

    await execute(() async {
      final image = await cameraController!.takePicture();

      capturedImage = File(image.path);

      notifyListeners();
    });
  }

  void retakeImage() {
    capturedImage = null;
    notifyListeners();
  }

  Future<void> disposeCamera() async {
    await cameraController?.dispose();

    cameraController = null;

    notifyListeners();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
