/*..............................................................................
 . Copyright (c)
 .
 . The classification_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/28/21 3:20 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ClassificationService {
  static Future<List<String>> labelFile(File file) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(file);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    var labels = await labeler.processImage(visionImage);

    var highAccuracy = labels.where((label) => label.confidence >= .75);
    var lowAccuracy = labels.where((label) => label.confidence < .75 && label.confidence > .50);

    List<String> labelsToSave = [];

    if (highAccuracy.isNotEmpty) {
      labelsToSave = highAccuracy.map((label) => label.text).toList();
    } else {
      labelsToSave = lowAccuracy.take(5).map((label) => label.text).toList();
    }

    labeler.close();
    return labelsToSave;
  }
}
