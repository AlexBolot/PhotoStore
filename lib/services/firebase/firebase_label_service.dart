/*..............................................................................
 . Copyright (c)
 .
 . The firebase_label_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 10/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseLabelService {
  static String _labelsField = 'labels';
  static Map<String, int> _globalLabels;

  static List<String> get globalLabels {
    return _globalLabels.keys.toList()..sort();
  }

  /// Fetches the labels for a single file
  static Future<List<String>> getFileLabels(SavePath savePath) async {
    DocumentReference document = _getDocument(savePath);
    var content = (await document.get()).data();
    var labels = content.get(_labelsField, orDefault: []).cast<String>();
    logFetch('fetching labels : $labels');

    return labels;
  }

  /// Saves the labels for a single file
  static Future<void> saveFileLabels(SavePath savePath, List<String> labels) async {
    DocumentReference document = _getDocument(savePath);
    document.upsert({_labelsField: labels});
  }

  /// Fetches the global list of labels
  static Future<void> fetchAllLabels() async {
    DocumentReference document = _getGlobalLabelsDocument();
    var content = (await document.get()).data();
    _globalLabels = Map<String, int>.from(content);
    logFetch('fetched all labels : $_globalLabels');
  }

  static List<String> getGlobalLabels() {
    fetchAllLabels();
    return _globalLabels.keys.toList()..sort();
  }

  static void addGlobalLabel(String label) {
    DocumentReference document = _getGlobalLabelsDocument();
    _globalLabels.putIfAbsent(label, () => 0);
    _globalLabels[label]++;
    document.set(_globalLabels);
  }

  static void deleteGlobalLabel(String label) {
    DocumentReference document = _getGlobalLabelsDocument();
    _globalLabels[label]--;
    _globalLabels.removeWhere((key, value) => value == 0);
    document.set(_globalLabels);
  }

  // ------------------ Private methods ------------------ //

  static DocumentReference _getGlobalLabelsDocument() {
    var firestore = FirebaseFirestore.instance;
    var collection = firestore.collection('Autre');

    return collection.doc('Labels');
  }

  static DocumentReference _getDocument(SavePath savePath) {
    var firestore = FirebaseFirestore.instance;
    var collectionName = '${AccountService.currentAccount.name}';
    var collection = firestore.collection(collectionName);

    return collection.doc(savePath.fileName);
  }
}
