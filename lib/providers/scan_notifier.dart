import 'dart:io';
import 'package:camera/camera.dart';
import 'package:snapnotes/features/scan/domain/scan_mode.dart';

import '../core/state/base_notifier.dart';

class ScanNotifier extends BaseNotifier {
  CameraController? cameraController;

  List<CameraDescription> cameras = [];

  File? capturedImage;

  ScanMode selectedMode = ScanMode.document;

  void changeMode(ScanMode mode) {
    selectedMode = mode;
    notifyListeners();
  }

  void setCapturedImage(File image) {
    capturedImage = image;

    notifyListeners();
  }

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

  Future<File?> captureImage() async {
    if (cameraController == null) {
      return null;
    }

    final image = await cameraController!.takePicture();

    return File(image.path);
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
