/*..............................................................................
 . Copyright (c)
 .
 . The cache_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/firebase/firebase_album_service.dart';
import 'package:photo_store/services/firebase/firebase_file_service.dart';
import 'package:photo_store/services/logging_service.dart';

class CacheService {
  static String _localAppDirectory;

  static Future<void> freeSpaceOnDevice([Duration delay = const Duration(days: 30)]) async {
    var albums = await FirebaseAlbumService.fetchAllAlbums();

    List<AttemptResult> results = [];

    for (var album in albums) {
      for (var firebaseFile in album.firebaseFiles) {
        var lastAccess = await FirebaseFileService.getLastAccess(firebaseFile.savePath);
        var chosenDate = DateTime.now().subtract(delay);

        if (lastAccess != null && lastAccess.isBefore(chosenDate)) {
          results.add(await deleteLocalCopy(firebaseFile.savePath));
        }
      }
    }

    // Checking if every result is successful
    var finalResult = AttemptResult(results.every((result) => result.value));
    var successes = results.count((result) => result.value);

    logResult('Deleting $successes/${results.length} files', finalResult);
    FirebaseAlbumService.refresh();
  }

  static Future<AttemptResult> deleteLocalCopy(SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;

    var file = File(_localAppDirectory + '/' + savePath.formatted);

    if (file.existsSync()) {
      file.deleteSync();
      FirebaseFileService.saveLastAccess(savePath, reset: true);
      return AttemptResult.success;
    }

    return AttemptResult.fail;
  }
}
