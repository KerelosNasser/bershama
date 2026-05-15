import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService extends GetxService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> recognizeText(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      return '';
    }
  }

  @override
  void onClose() {
    _textRecognizer.close();
    super.onClose();
  }
}
