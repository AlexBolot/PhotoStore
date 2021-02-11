/*..............................................................................
 . Copyright (c)
 .
 . The cache_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 12/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/firebase/firebase_album_service.dart';
import 'package:photo_store/services/firebase/firebase_file_service.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/utils/extensions.dart';

class CacheService {
  static Future<String> get _localAppDirectory async => (await getApplicationDocumentsDirectory()).path;

  static Future<void> freeSpaceOnDevice([Duration delay = const Duration(days: 30)]) async {
    var albums = await FirebaseAlbumService.fetchAllAlbums();

    List<AttemptResult> results = [];

    for (var album in albums) {
      for (var firebaseFile in album.firebaseFiles) {
        var lastAccess = await FirebaseFileService.getLastAccess(firebaseFile.name);
        var chosenDate = DateTime.now().subtract(delay);

        if (lastAccess != null && lastAccess.isBefore(chosenDate)) {
          var path = SavePath(firebaseFile.albumName, firebaseFile.name);
          results.add(await deleteLocalCopy(path));
        }
      }
      album.refresh();
    }

    // Checking if every result is successful
    var finalResult = AttemptResult(results.every((result) => result.value));
    var successes = results.count((result) => result.value);

    logResult('Deleting $successes/${results.length} files', finalResult);
    FirebaseAlbumService.refresh();
  }

  static Future<AttemptResult> deleteLocalCopy(SavePath savePath) async {
    var file = File(await _localAppDirectory + '/' + savePath.fileName);

    if (file.existsSync()) {
      file.deleteSync();
      FirebaseFileService.saveLastAccess(savePath.fileName, reset: true);
      return AttemptResult.success;
    }

    logWarning('Failed to delete ${file.path}');
    return AttemptResult.fail;
  }
}
