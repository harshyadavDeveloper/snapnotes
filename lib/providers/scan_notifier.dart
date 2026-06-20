import 'dart:io';

import 'package:camera/camera.dart';

import '../core/state/base_notifier.dart';

class ScanNotifier extends BaseNotifier {
  CameraController? cameraController;

  List<CameraDescription> cameras = [];

  File? capturedImage;

  Future<void> initializeCamera() async {
    await execute(() async {
      cameras = await availableCameras();

      cameraController = CameraController(cameras.first, ResolutionPreset.high);

      await cameraController!.initialize();

      notifyListeners();
    });
  }

  Future<void> disposeCamera() async {
    await cameraController?.dispose();
  }
}
