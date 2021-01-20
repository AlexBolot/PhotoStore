/*..............................................................................
 . Copyright (c)
 .
 . The firebase_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/20/21 9:16 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<AttemptResult> saveImage(File image, [List<String> labels = const []]) async {
    String imagePath = '${image.path.split('/').last}';

    logStep('Saving image $imagePath');

    try {
      String downloadUrl = await _uploadFile(imagePath, image);
      await _uploadMetaData(imagePath, downloadUrl, labels);
      return AttemptResult.success;
    } on Exception catch (e) {
      logDebug(e);
      return AttemptResult.fail;
    }
  }

  // ---------- Private methods ------------- //

  static Future<String> _uploadFile(String imagePath, File image) async {
    var folder = AccountService.currentAccount.name;

    var storageReference = _storage.ref().child('$folder/$imagePath');
    var uploadTask = storageReference.putFile(image);

    await uploadTask.whenComplete(() => logDebug('File Uploaded to $folder/$imagePath'));
    return await storageReference.getDownloadURL();
  }

  static _uploadMetaData(String path, String url, List<String> labels) async {
    var collection = _firestore.collection(AccountService.currentAccount.name);

    await collection.doc(path).set({'downloadUrl': url});
    logDebug('Saved downloadUrl');
    await collection.doc(path).update({'labels': labels});
    logDebug('Saved labels $labels');
  }
}
