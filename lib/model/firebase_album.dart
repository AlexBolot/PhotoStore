/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 5:27 PM
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

  List<FirebaseFile> _files;
  File _thumbnail;
  int _count;

  FirebaseAlbum(Reference ref) {
    this.reference = ref;
    this.name = ref.name;
  }

  Future<int> get count async {
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
    return _files ??= await _loadFiles();
  }

  Future<File> get thumbnail async {
    if (_thumbnail != null) return _thumbnail;

    var firstFile = (await files).first;
    return _thumbnail = await firstFile.file;
  }

  Future<List<FirebaseFile>> _loadFiles() async {
    ListResult list = await reference.listAll();
    var files = list.items.map((fileReference) => FirebaseFile(fileReference)).toList();
    logDebug("loaded ${files.length} fiels for album '$name'");
    return files;
  }

  _loadFilesCount() async {
    ListResult list = await reference.listAll();
    return list.items.length;
  }
}
