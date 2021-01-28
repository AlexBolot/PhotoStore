/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/28/21 3:16 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseAlbum {
  String name;
  Reference reference;

  List<FirebaseFile> _firebaseFiles;
  File _thumbnail;

  FirebaseAlbum(Reference ref) {
    this.reference = ref;
    this.name = ref.name;
  }

  Future<int> get count async => (await firebaseFiles).length;

  Future<List<FirebaseFile>> get firebaseFiles async => _firebaseFiles ??= await _loadFiles();

  Future<File> get thumbnail async => _thumbnail ??= await _loadThumbnail();

  Future<List<FirebaseFile>> _loadFiles() async {
    ListResult list = await reference.listAll();
    var files = list.items.map((fileReference) => FirebaseFile(fileReference)).toList();
    logDebug("loaded ${files.length} files for album '$name'");
    return files;
  }

  Future<File> _loadThumbnail() async {
    var firstFirebaseFile = (await firebaseFiles).first;
    return await firstFirebaseFile.file;
  }
}
