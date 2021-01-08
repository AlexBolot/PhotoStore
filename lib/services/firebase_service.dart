/*..............................................................................
 . Copyright (c)
 .
 . The firebase_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/8/21 10:13 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final Firestore _firestore = Firestore.instance;
  static final FirebaseAuth mAuth = FirebaseAuth.instance;

  CollectionReference pictures = _firestore.collection("Pictures");

  Future<void> saveImages(List<File> images) async {
    images.forEach((image) async {
      String imagePath = '${image.path.split('/').last}';
      String downloadUrl = await uploadFile(imagePath, image);
      await uploadDownloadUrl(imagePath, downloadUrl);
    });
  }

  Future<String> uploadFile(String imagePath, File image) async {
    var storageReference = _storage.ref().child('Pictures/$imagePath');
    var uploadTask = storageReference.putFile(image);

    await uploadTask.onComplete;
    print('File Uploaded to Pictures/${image.path}');

    return await storageReference.getDownloadURL();
  }

  uploadDownloadUrl(String path, String url) async {
    CollectionReference pictures = _firestore.collection("Pictures");
    pictures.document(path).setData({'downloadUrl': url});
  }
}
