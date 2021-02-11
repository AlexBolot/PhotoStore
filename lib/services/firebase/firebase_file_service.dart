/*..............................................................................
 . Copyright (c)
 .
 . The firebase_file_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 11/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/utils/extensions.dart';
import 'package:photo_store/utils/firebase_accessors.dart';

class FirebaseFileService {
  static Future<String> get _localAppDirectory async => (await getApplicationDocumentsDirectory()).path;

  // ------------------ Get/Save File ------------------ //

  static Future<File> getFile(Reference reference, String fileName) async {
    var localFile = File(await _localAppDirectory + '/' + fileName);
    saveLastAccess(fileName);

    if (localFile.existsSync()) {
      return localFile;
    } else {
      var downloadUrl = await reference.getDownloadURL();
      return await downloadFile(downloadUrl, fileName);
    }
  }

  static Future<File> downloadFile(String url, String fileName) async {
    HttpClientRequest request = await HttpClient().getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    logDownload('downloaded file $fileName');

    return saveFile(bytes, fileName);
  }

  static Future<File> saveFile(List<int> bytes, String fileName) async {
    var directory = Directory(await _localAppDirectory);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    var path = directory.path + '/' + fileName;

    return File(path)..writeAsBytesSync(bytes);
  }

  // ------------------ Get/Save Last Access ------------------ //

  /// Returns a Timestamp.toDate or null
  static Future<DateTime> getLastAccess(String fileName) async {
    var document = await getFileDocument(fileName);
    var lastAccess = await document.getData(FirebaseFields.lastAccess);
    return lastAccess?.toDate();
  }

  static Future<void> saveLastAccess(String fileName, {bool reset = false}) async {
    DocumentReference document = await getFileDocument(fileName);

    if (reset) {
      await document.update({FirebaseFields.lastAccess: null});
      logUpdate('reset ${FirebaseFields.lastAccess} for $fileName');
    } else {
      var newDate = DateTime.now();
      await document.update({FirebaseFields.lastAccess: newDate});
      logUpdate('saved ${FirebaseFields.lastAccess} ${newDate.toEuropeanFormat()} for $fileName');
    }
  }
}
