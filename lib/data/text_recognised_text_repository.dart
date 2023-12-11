import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../model/images_model.dart';
import '../utils/db_helper.dart';

class RecognisedTextRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<String> getRecognisedText(XFile imageFile) async {
    String scannedText = "";
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }

    return scannedText;
  }

  Future<CroppedFile?> cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: const Color(0xFF20ac6d),
            cropGridColor: const Color(0xFF20ac6d),
            activeControlsWidgetColor: const Color(0xFF20ac6d),
            statusBarColor: const Color(0xFF20ac6d),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false)
      ],
    );
    if (croppedFile != null) {
      return croppedFile;
    }
    return null;
  }

  saveImage(XFile image, String scannedText) async {
    Directory directory = await getApplicationDocumentsDirectory();

    final String localPath = directory.path;
    debugPrint('Temp path :- ${directory.path}');
    File tmpFile = File(image.path);
    tmpFile = await tmpFile.copy('$localPath/${image.path.split('/').last}');
    DateTime now = DateTime.now();
    String date = DateFormat('kk:mm:ss EEE d MMM').format(now);
    await dbHelper
        .insertImage(ScannedImageModel(scannedText, tmpFile.path, date, "0"));
  }
}
