/*..............................................................................
 . Copyright (c)
 .
 . The upload_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 11/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/firebase/firebase_album_service.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/utils/extensions.dart';
import 'package:photo_store/utils/firebase_accessors.dart';
import 'package:photo_store/utils/global.dart';

class UploadService {
  static String get _userName => AccountService.currentAccount.name;

  /// Saves a file in 2 steps
  ///
  /// 1. Uploading the file to Storage
  /// 2. Uploading the labels and download URL to Firestore
  ///
  static Future<AttemptResult> uploadFile(File file, SavePath savePath, [List<String> labels = const []]) async {
    logStep('Saving file ${savePath.formatted}');

    try {
      await _uploadFile(savePath.fileName, file);
      await _uploadMetaData(savePath.fileName, labels);
      FirebaseAlbumService.addToAlbum(savePath);
      return AttemptResult.success;
    } on Exception catch (e) {
      logWarning(e);
      return AttemptResult.fail;
    }
  }

  /// ⚠️ deprecated
  /// Use this only to send all images from phone to firebase.
  /// This is not a normal use-case (only during development)
  static Future<void> uploadWithLabels() async {
    Directory appDocumentsDirectory = await getExternalStorageDirectory();
    var directories = appDocumentsDirectory.listSync();

    logDebug('loading files from : ${appDocumentsDirectory.path}');

    List<AttemptResult> results = [];

    for (var directory in directories) {
      if (directory is Directory) {
        var dirName = directory.path.split('/').last;
        var start = getTime();
        var count = 0;

        logDebug('------ $dirName ------');

        for (var item in directory.listSync()) {
          if (count > 10) continue;

          var imageName = item.path.split('/').last;

          if (item is File && _isImage(imageName)) {
            logDebug('-- $imageName');

            var result = await uploadFile(item, SavePath(dirName, imageName));
            results.add(result);
            count++;
          }
        }

        logDelay('Uploaded $count images for /$dirName', start, getTime());
      }
    }

    // Checking if every result is successful
    var finalResult = AttemptResult(results.every((result) => result.value));
    var successes = results.count((result) => result.value);

    logResult('Uploading $successes/${results.length} files', finalResult);
  }

  // ------------------ Private methods ------------------ //

  static Future<void> _uploadFile(String fileName, File file) async {
    var fileReference = getFileReference(fileName);
    var uploadTask = fileReference.putFile(file);

    await uploadTask.whenComplete(() => logInfo('File Uploaded to $_userName/$fileName'));
  }

  static Future<void> _uploadMetaData(String fileName, List<String> labels) async {
    DocumentReference document = await getFileDocument(fileName);

    await document.update({FirebaseFields.labels: labels});
    logDebug('Saved labels ${labels.join(' ')}');
  }

  static bool _isImage(String fileName) {
    var fileExtension = fileName.split('.').last.toLowerCase();
    return ['jpg', 'png', 'jpeg'].contains(fileExtension);
  }
}
