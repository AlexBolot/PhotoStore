/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 12/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/utils/extensions.dart';

class FirebaseAlbum {
  String name;
  int index;
  List<FirebaseFile> firebaseFiles;
  List<String> fileNames;

  FirebaseAlbum(this.name, this.index, this.fileNames) {
    refresh();
  }

  FirebaseAlbum.fromMap(Map data) {
    this.name = data['name'];
    this.index = data['index'];
    this.fileNames = data['file_names'].cast<String>();

    refresh();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'index': this.index,
      'file_names': this.fileNames,
    };
  }

  // ------------------ Getters ------------------ //

  Future<int> get count async => firebaseFiles.length;

  Future<File> get thumbnail async => await firebaseFiles.first.file;

  // ------------------ Methods ------------------ //

  Future<List<FirebaseFile>> filter(String label) async {
    return firebaseFiles.whereAsync((x) async => await x.hasLabel(label));
  }

  void refresh() => this.firebaseFiles = fileNames.map((fileName) => FirebaseFile(fileName, name)).toList();

  void addFile(String fileName) => this.firebaseFiles.add(FirebaseFile(fileName, name));

  @override
  bool operator ==(Object other) {
    if (other is FirebaseAlbum) return name == other.name;
    if (other is String) return name == other;
    return false;
  }

  @override
  int get hashCode => name.hashCode;
}
