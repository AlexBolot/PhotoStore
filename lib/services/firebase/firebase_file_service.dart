/*..............................................................................
 . Copyright (c)
 .
 . The firebase_file_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/28/21 3:20 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/firebase/download_service.dart';
import 'package:photo_store/services/gallery_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseFileService {
  static String _localAppDirectory;
  static String _lastAccessField = 'last_access';

  static Future<File> getFile(Reference reference, SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;

    var localFile = File(_localAppDirectory + '/' + savePath.formatted);
    _updateLastAccess(savePath);

    if (localFile.existsSync()) {
      return localFile;
    } else {
      logDebug('must download ${savePath.formatted}');
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

  static Future<void> freeSpaceOnDevice([Duration delay = const Duration(days: 30)]) async {
    var albums = await DownloadService.downloadAlbums();

    List<AttemptResult> results = [];

    for (var album in albums) {
      var firebaseFiles = await album.firebaseFiles;

      for (var firebaseFile in firebaseFiles) {
        var lastAccess = await getLastAccess(firebaseFile.savePath);
        var thirtyDaysAgo = DateTime.now().subtract(delay);

        if (lastAccess != null && lastAccess.isBefore(thirtyDaysAgo)) {
          results.add(await deleteLocalCopy(firebaseFile.savePath));
        }
      }
    }

    // Checking if every result is successful
    var finalResult = AttemptResult(results.every((result) => result.value));
    logResult("Deleting ${results.length} files", finalResult);
    GalleryService.refreshFirebaseAlbums();
  }

  static Future<AttemptResult> deleteLocalCopy(SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;

    var file = File(_localAppDirectory + '/' + savePath.formatted);

    if (file.existsSync()) {
      file.deleteSync();
      _updateLastAccess(savePath, reset: true);
      return AttemptResult.success;
    }

    return AttemptResult.fail;
  }

  /// May return null
  static Future<DateTime> getLastAccess(SavePath savePath) async {
    DocumentReference document = _getDocument(savePath);
    Map<String, dynamic> data = (await document.get()).data();

    if (data.containsKey(_lastAccessField)) {
      Timestamp lastAccess = data[_lastAccessField];
      return lastAccess?.toDate();
    } else {
      return null;
    }
  }

  // ------------------ Private methods ------------------ //

  static Future<void> _updateLastAccess(SavePath savePath, {bool reset = false}) async {
    DocumentReference document = _getDocument(savePath);
    var newDate = reset ? null : DateTime.now();

    await document.update({_lastAccessField: newDate});
    logDebug('saved $_lastAccessField $newDate for ${savePath.fileName}');
  }

  static DocumentReference _getDocument(SavePath savePath) {
    var firestore = FirebaseFirestore.instance;
    var collectionName = '${AccountService.currentAccount.name}_${savePath.directory}';
    var collection = firestore.collection(collectionName);

    return collection.doc(savePath.fileName);
  }
}
