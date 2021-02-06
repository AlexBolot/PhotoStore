/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseAlbum {
  String name;
  Reference reference;

  List<FirebaseFile> _firebaseFiles;

  FirebaseAlbum(Reference ref) {
    this.reference = ref;
    this.name = ref.name;
  }

  // ------------------ Getters ------------------ //

  Future<int> get count async => (await firebaseFiles).length;

  Future<List<FirebaseFile>> get firebaseFiles async => _firebaseFiles ??= await _loadFiles();

  Future<File> get thumbnail async => await _loadThumbnail();

  Future<List<FirebaseFile>> filter(String label) async {
    List<FirebaseFile> result = [];

    var firebaseFiles = await this.firebaseFiles;

    for (var firebaseFile in firebaseFiles) {
      if (await firebaseFile.hasLabel(label)) {
        result.add(firebaseFile);
      }
    }

    return result;
  }

  // ------------------ Private methods ------------------ //

  Future<List<FirebaseFile>> _loadFiles() async {
    ListResult list = await reference.listAll();
    var files = list.toFirebaseFile();
    logFetch("found ${files.length} files for album '$name'");
    return files;
  }

  Future<File> _loadThumbnail() async {
    var firstFirebaseFile = (await firebaseFiles).first;
    return await firstFirebaseFile.file;
  }
}
