/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:45 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseAlbum {
  String name;
  Reference reference;

  List<FirebaseFile> _files;
  int _count;

  FirebaseAlbum(Reference ref) {
    this.reference = ref;
    this.name = ref.name;

    logDebug('Created album ${this.name}');
  }

  Future<int> get count async {
    logDebug('accessing count');
    if (_count == null) {
      if (_files != null) {
        _count = _files.length;
      } else {
        _count = await _loadFilesCount();
      }
    }

    return _count;
  }

  Future<List<FirebaseFile>> get files async {
    logDebug('Accessing files of ${this.name}');
    return _files ??= await _loadFiles();
  }

  Future<FirebaseFile> get thumbnail async => (await files).first;

  _loadFiles() async {
    ListResult list = await reference.listAll();
    return list.items.map((fileReference) => FirebaseFile(fileReference)).toList();
  }

  /// Load only the first file from firebase
  Future<FirebaseFile> _loadThumbnail() async {
    ListResult list = await reference.listAll();
    var firebaseFile = FirebaseFile(list.items.first);
    return firebaseFile;
  }

  _loadFilesCount() async {
    ListResult list = await reference.listAll();
    return list.items.length;
  }
}
