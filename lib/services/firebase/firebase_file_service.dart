/*..............................................................................
 . Copyright (c)
 .
 . The firebase_file_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseFileService {
  static String _localAppDirectory;
  static String _lastAccessField = 'last_access';
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String get _userName => AccountService.currentAccount.name;

  // ------------------ Get/Save File ------------------ //

  static Future<File> getFile(Reference reference, SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;

    var localFile = File(_localAppDirectory + '/' + savePath.fileName);
    saveLastAccess(savePath);

    if (localFile.existsSync()) {
      return localFile;
    } else {
      var downloadUrl = await reference.getDownloadURL();
      return await downloadFile(downloadUrl, savePath);
    }
  }

  static Future<File> downloadFile(String url, SavePath savePath) async {
    HttpClientRequest request = await HttpClient().getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    logDownload('downloaded file ${savePath.fileName}');

    return saveFile(bytes, savePath);
  }

  static Future<File> saveFile(List<int> bytes, SavePath savePath) async {
    var directory = await _getLocalDirectory();

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    var path = directory.path + '/' + savePath.fileName;

    return File(path)..writeAsBytesSync(bytes);
  }

  // ------------------ Get/Save Last Access ------------------ //

  /// May return null
  static Future<DateTime> getLastAccess(SavePath savePath) async {
    DocumentReference document = _getDocument(savePath);
    var content = (await document.get()).data();

    // Returns a Timestamp.toDate or null
    return content.get(_lastAccessField)?.toDate();
  }

  static Future<void> saveLastAccess(SavePath savePath, {bool reset = false}) async {
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
    var collectionName = '${_userName}_${savePath.directory}';
    var collection = _firestore.collection(collectionName);
    return collection.doc(savePath.fileName);
  }

  static Future<Directory> _getLocalDirectory() async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;
    return Directory(_localAppDirectory);
  }
}
