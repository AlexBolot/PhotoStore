/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/22/21 9:16 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_store/model/firebase_file.dart';

class FirebaseAlbum {
  String name;
  Reference reference;

  FirebaseFile _thumbnail;
  List<FirebaseFile> _files;
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
    if (_thumbnail == null) {
      return _thumbnail = _files == null ? _files.first : await _loadThumbnail();
    }

    return _thumbnail.file;
  }

  _loadFiles() async {
    ListResult list = await reference.listAll();
    return list.items.map((fileReference) => FirebaseFile(fileReference)).toList();
  }

  /// Load only the first file from firebase
  _loadThumbnail() async {
    ListResult list = await reference.list(ListOptions(maxResults: 1));
    return FirebaseFile(list.items.first);
  }

  _loadFilesCount() async {
    ListResult list = await reference.listAll();
    return list.items.length;
  }
}
