/*..............................................................................
 . Copyright (c)
 .
 . The firebase_file_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 2/4/21 4:35 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/firebase/download_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseFileService {
  static String _localAppDirectory;
  static String _lastAccessField = 'last_access';
  static String _labelsField = 'labels';

  static Future<File> getFile(Reference reference, SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;

    var localFile = File(_localAppDirectory + '/' + savePath.formatted);
    updateLastAccess(savePath);

    if (localFile.existsSync()) {
      return localFile;
    } else {
      var downloadUrl = await reference.getDownloadURL();
      return await DownloadService.downloadFile(downloadUrl, savePath);
    }
  }

  static Future<File> saveFile(List<int> bytes, SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;
    var directory = Directory(_localAppDirectory + '/' + savePath.directory);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    var file = File(directory.path + '/' + savePath.fileName);

    file.writeAsBytesSync(bytes);

    return file;
  }

  /// May return null
  static Future<DateTime> getLastAccess(SavePath savePath) async {
    DocumentReference document = _getDocument(savePath);
    var content = (await document.get()).data();

    // Returns a Timestamp.toDate or null
    return content.get(_lastAccessField)?.toDate();
  }

  static Future<List<String>> getLabels(SavePath savePath) async {
    DocumentReference document = _getDocument(savePath);
    var content = (await document.get()).data();
    var labels = content.get(_labelsField, orDefault: []).cast<String>();
    logFetch('fetching labels : $labels');

    return labels;
  }

  static Future<void> setLabels(SavePath savePath, List<String> labels) async {
    DocumentReference document = _getDocument(savePath);
    document.update({_labelsField: labels});
  }

  static Future<void> updateLastAccess(SavePath savePath, {bool reset = false}) async {
    DocumentReference document = _getDocument(savePath);

    if (reset) {
      await document.update({_lastAccessField: null});
      logUpdate('reset $_lastAccessField for ${savePath.fileName}');
    } else {
      var newDate = DateTime.now();
      await document.update({_lastAccessField: newDate});
      logUpdate('saved $_lastAccessField ${newDate.toEuropeanFormat()} for ${savePath.fileName}');
    }
  }

  // ------------------ Private methods ------------------ //

  static DocumentReference _getDocument(SavePath savePath) {
    var firestore = FirebaseFirestore.instance;
    var collectionName = '${AccountService.currentAccount.name}_${savePath.directory}';
    var collection = firestore.collection(collectionName);

    return collection.doc(savePath.fileName);
  }
}
