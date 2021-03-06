/*..............................................................................
 . Copyright (c)
 .
 . The firebase_label_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/utils/extensions.dart';
import 'package:photo_store/utils/firebase_accessors.dart';

class FirebaseLabelService {
  static Map<String, int> _globalLabels;

  static List<String> get globalLabels {
    return _globalLabels.keys.toList()..sort();
  }

  /// Fetches the labels for a single file
  static Future<List<String>> getFileLabels(String fileName) async {
    DocumentReference document = await getFileDocument(fileName);
    List<String> labels = (await document.getData(FirebaseFields.labels, [])).cast<String>();

    logFetch('fetching labels : $labels');

    return labels;
  }

  /// Saves the labels for a single file
  static Future<void> saveFileLabels(String fileName, List<String> labels) async {
    DocumentReference document = await getFileDocument(fileName);
    document.update({FirebaseFields.labels: labels});
  }

  /// Fetches the global list of labels
  static Future<void> fetchAllLabels() async {
    DocumentReference document = await getLabelsDocument();

    var content = await document.getMap();
    _globalLabels = Map<String, int>.from(content);
    logFetch('fetched all labels : $_globalLabels');
  }

  static List<String> getGlobalLabels() {
    fetchAllLabels();
    return _globalLabels.keys.toList()..sort();
  }

  static void addGlobalLabel(String label) {
    _globalLabels.add(label, 0);
    _globalLabels[label]++;
    getLabelsDocument().then((doc) => doc.update(_globalLabels));
  }

  static void deleteGlobalLabel(String label) {
    _globalLabels[label]--;
    _globalLabels.removeWhere((key, value) => value == 0);
    getLabelsDocument().then((doc) => doc.update(_globalLabels));
  }
}
