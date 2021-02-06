/*..............................................................................
 . Copyright (c)
 .
 . The cache_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 2/4/21 7:20 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/firebase/download_service.dart';
import 'package:photo_store/services/firebase/firebase_file_service.dart';
import 'package:photo_store/services/gallery_service.dart';
import 'package:photo_store/services/logging_service.dart';

class CacheService {
  static String _localAppDirectory;

  static Future<void> freeSpaceOnDevice([Duration delay = const Duration(days: 30)]) async {
    var albums = await DownloadService.downloadAlbums();

    List<AttemptResult> results = [];

    for (var album in albums) {
      var firebaseFiles = await album.firebaseFiles;

      for (var firebaseFile in firebaseFiles) {
        var lastAccess = await FirebaseFileService.getLastAccess(firebaseFile.savePath);
        var thirtyDaysAgo = DateTime.now().subtract(delay);

        if (lastAccess != null && lastAccess.isBefore(thirtyDaysAgo)) {
          results.add(await deleteLocalCopy(firebaseFile.savePath));
        }
      }
    }

    // Checking if every result is successful
    var finalResult = AttemptResult(results.every((result) => result.value));
    var successes = results.count((result) => result.value);

    logResult('Deleting $successes/${results.length} files', finalResult);
    GalleryService.refreshFirebaseAlbums();
  }

  static Future<AttemptResult> deleteLocalCopy(SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;

    var file = File(_localAppDirectory + '/' + savePath.formatted);

    if (file.existsSync()) {
      file.deleteSync();
      FirebaseFileService.updateLastAccess(savePath, reset: true);
      return AttemptResult.success;
    }

    return AttemptResult.fail;
  }
}
