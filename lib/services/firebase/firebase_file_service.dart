/*..............................................................................
 . Copyright (c)
 .
 . The firebase_file_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/27/21 4:57 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/firebase/download_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseFileService {
  static String _localAppDirectory;
  static String _lastAccessField = 'last_access';

  static Future<File> getFile(String downloadUrl, SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;

    var localFile = File(_localAppDirectory + '/' + savePath.formatted);
    _updateLastAccess(savePath);

    if (localFile.existsSync()) {
      return localFile;
    } else {
      logDebug('Must download ${savePath.formatted}');
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

  static freeSpaceOnDevice() async {
    var albums = await DownloadService.downloadAlbums();

    for (var album in albums) {
      var firebaseFiles = await album.files;

      for (var firebaseFile in firebaseFiles) {
        var lastAccess = await getLastAccess(firebaseFile.fullPath);
        var thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));

        if (lastAccess != null && lastAccess.isBefore(thirtyDaysAgo)) {
          (await firebaseFile.file).delete();
          logDebug('Deleted ${firebaseFile.name}');
        }
      }
    }
  }

  static getLastAccess(SavePath savePath) async {
    DocumentReference document = _getDocument(savePath);
    DocumentSnapshot snapshot = await document.get();

    Timestamp lastAccess = snapshot.get(_lastAccessField);
    return lastAccess?.toDate();
  }

  // ------------------ Private methods ------------------ //

  static Future<void> _updateLastAccess(SavePath savePath) async {
    DocumentReference document = _getDocument(savePath);
    var now = DateTime.now();

    await document.update({_lastAccessField: now});
    logDebug('saved $_lastAccessField $now for ${savePath.fileName}');
  }

  static DocumentReference _getDocument(SavePath savePath) {
    var firestore = FirebaseFirestore.instance;
    var collectionName = '${AccountService.currentAccount.name}_${savePath.directory}';
    var collection = firestore.collection(collectionName);

    return collection.doc(savePath.fileName);
  }
}
