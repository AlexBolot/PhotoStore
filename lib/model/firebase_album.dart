/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 11/02/2021
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

  FirebaseAlbum(this.name, this.index, List<String> fileNames) {
    this.firebaseFiles = fileNames.map((fileName) => FirebaseFile(fileName, name)).toList();
  }

  FirebaseAlbum.fromMap(Map data) {
    this.name = data['name'];
    this.index = data['index'];

    List<String> fileNames = data['file_names'].cast<String>();
    this.firebaseFiles = fileNames.map((name) => FirebaseFile(name, this.name)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'index': this.index,
      'file_names': this.firebaseFiles.map((firebaseFile) => firebaseFile.name).toList(),
    };
  }

  // ------------------ Getters ------------------ //

  Future<int> get count async => firebaseFiles.length;

  Future<File> get thumbnail async => await firebaseFiles.first.file;

  List<String> get fileNames => firebaseFiles.map((x) => x.name);

  // ------------------ Methods ------------------ //

  Future<List<FirebaseFile>> filter(String label) async {
    return firebaseFiles.whereAsync((x) async => await x.hasLabel(label));
  }

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
