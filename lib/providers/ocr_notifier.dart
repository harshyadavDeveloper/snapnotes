import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../core/state/base_notifier.dart';

class OcrNotifier extends BaseNotifier {
  String extractedText = '';

  Future<void> recognizeText(File image) async {
    await execute(() async {
      final recognizer = TextRecognizer();

      final inputImage = InputImage.fromFile(image);

      final result = await recognizer.processImage(inputImage);

      extractedText = result.text;

      await recognizer.close();

      notifyListeners();
    });
  }

  void clear() {
    extractedText = '';

    notifyListeners();
  }
}
