/*..............................................................................
 . Copyright (c)
 .
 . The firebase_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/7/21 11:47 AM
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

  DocumentReference pictures = _firestore.collection("Pictures").document();

  //await saveImages(_images,sightingRef);

  Future<void> saveImages(List<File> _images) async {
    _images.forEach((image) async {
      String imageURL = await uploadFile(image);
      pictures.updateData({
        "images": FieldValue.arrayUnion([imageURL])
      });
    });
  }

  Future<String> uploadFile(File _image) async {
    var storageReference = _storage.ref().child('Pictures/${_image.path.split('/').last}');
    var uploadTask = storageReference.putFile(_image);

    await uploadTask.onComplete;
    print('File Uploaded to Pictures/${_image.path}');

    return await storageReference.getDownloadURL();
  }
}
