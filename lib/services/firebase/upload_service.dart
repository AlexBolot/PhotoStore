/*..............................................................................
 . Copyright (c)
 .
 . The upload_service.dart class was created by : Alex Bolot and Pierre Bolot
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
import 'package:photo_store/services/classification_service.dart';
import 'package:photo_store/services/logging_service.dart';

class UploadService {
  /// Saves a file in 2 steps
  ///
  /// 1. Uploading the file to Storage
  /// 2. Uploading the labels and download URL to Firestore
  ///
  static Future<AttemptResult> saveFile(File image, SavePath savePath, [List<String> labels = const []]) async {
    logStep('Saving file ${savePath.formatted}');

    try {
      String downloadUrl = await _uploadFile(savePath, image);
      await _uploadMetaData(savePath, downloadUrl, labels);
      return AttemptResult.success;
    } on Exception catch (e) {
      logWarning(e);
      return AttemptResult.fail;
    }
  }

  static Future<void> uploadWithLabels() async {
    Directory appDocumentsDirectory = await getExternalStorageDirectory();
    var directories = appDocumentsDirectory.listSync();

    logDebug('loading files from : ${appDocumentsDirectory.path}');

    directories.take(5).forEach((dir) async {
      if (dir is Directory) {
        int count = 0;

        logDebug('------ ${dir.path.split('/').last} ------');
        var dirName = dir.path.split('/').last;

        for (var item in dir.listSync()) {
          if (count > 10) return;

          if (item is File) {
            var fileExtension = item.path.split('.').last.toLowerCase();
            bool isImage = ['jpg', 'png', 'jpeg'].contains(fileExtension);

            if (isImage) {
              logDebug('-- ${item.path.split('/').last}');
              var imageName = item.path.split('/').last;

              var labels = await ClassificationService.labelFile(item);
              UploadService.saveFile(item, SavePath(dirName, imageName), labels);
              count++;
            }
          }
        }
      }
    });
  }

  // ------------------ Private methods ------------------ //

  /// Uploads a [file] to the Storage and returns its download URL
  ///
  static Future<String> _uploadFile(SavePath savePath, File file) async {
    Reference storageFolder = _getStorageFolder(savePath);

    var fileReference = storageFolder.child(savePath.fileName);
    var uploadTask = fileReference.putFile(file);

    await uploadTask.whenComplete(() => logInfo('File Uploaded to ${fileReference.fullPath}'));
    return await fileReference.getDownloadURL();
  }

  /// Uploads the labels and downloadURL of a [file] to the Firestore
  ///
  static Future<void> _uploadMetaData(SavePath savePath, String url, List<String> labels) async {
    DocumentReference document = _getDocument(savePath);

    await document.set({'downloadUrl': url});
    logDebug('Saved downloadUrl');
    await document.update({'labels': labels});
    logDebug('Saved labels ${labels.join(' ')}');
  }

  /// Return a Firestore Document based on the active user and the given path
  ///
  static DocumentReference _getDocument(SavePath savePath) {
    var firestore = FirebaseFirestore.instance;
    var collectionName = '${AccountService.currentAccount.name}_${savePath.directory}';
    var collection = firestore.collection(collectionName);

    return collection.doc(savePath.fileName);
  }

  /// Return a Storage reference (folder) based on the active user and the given directory path
  ///
  static Reference _getStorageFolder(SavePath savePath) {
    var storage = FirebaseStorage.instance.ref(AccountService.currentAccount.name);
    return storage.child(savePath.directory);
  }
}
