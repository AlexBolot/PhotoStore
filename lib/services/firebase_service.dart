/*..............................................................................
 . Copyright (c)
 .
 . The firebase_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/10/21 1:56 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth mAuth = FirebaseAuth.instance;

  static CollectionReference pictures = _firestore.collection("Pictures");

  static Future<AttemptResult> saveImage(File image) async {
    String imagePath = '${image.path.split('/').last}';

    logStep('Saving image $imagePath');

    try {
      String downloadUrl = await _uploadFile(imagePath, image);
      await _uploadDownloadUrl(imagePath, downloadUrl);
      return AttemptResult.success;
    } on Exception catch (e) {
      logDebug(e);
      return AttemptResult.fail;
    }
  }

  // ---------- Private methods ------------- //

  static Future<String> _uploadFile(String imagePath, File image) async {
    var storageReference = _storage.ref().child('Pictures/$imagePath');
    var uploadTask = storageReference.putFile(image);

    await uploadTask.whenComplete(() => logDebug('File Uploaded to Pictures/${image.path}'));
    return await storageReference.getDownloadURL();
  }

  static _uploadDownloadUrl(String path, String url) async {
    await pictures.doc(path).set({'downloadUrl': url});
    logDebug('Saved downloadUrl');
  }
}
