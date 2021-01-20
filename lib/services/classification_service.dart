/*..............................................................................
 . Copyright (c)
 .
 . The classification_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/20/21 9:16 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:photo_store/services/firebase_service.dart';
import 'package:photo_store/services/logging_service.dart';

class ClassificationService {
  static labelFile(File file) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(file);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    var labels = await labeler.processImage(visionImage);

    logDebug('----------------------');
    logDebug(file.path);

    var highAccuracy = labels.where((label) => label.confidence >= .75);
    var lowAccuracy = labels.where((label) => label.confidence < .75 && label.confidence > .50);

    List<String> labelsToSave = [];

    logDebug(labels.map((e) => '${e.text} - ${e.confidence}').toList());

    if (highAccuracy.isNotEmpty) {
      labelsToSave = highAccuracy.map((label) => label.text).toList();
    } else {
      labelsToSave = lowAccuracy.take(5).map((label) => label.text).toList();
    }

    FirebaseService.saveImage(file, labelsToSave);

    labeler.close();
  }
}
