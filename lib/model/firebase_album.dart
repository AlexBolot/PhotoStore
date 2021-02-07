/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/firebase_file.dart';

class FirebaseAlbum {
  String name;
  List<FirebaseFile> firebaseFiles;

  FirebaseAlbum(String name, List<String> fileNames) {
    this.name = name;
    this.firebaseFiles = fileNames.map((fileName) => FirebaseFile(fileName, name)).toList();
  }

  // ------------------ Getters ------------------ //

  Future<int> get count async => firebaseFiles.length;

  Future<File> get thumbnail async => await _loadThumbnail();

  List<String> get fileNames => firebaseFiles.map((x) => x.name);

  Future<List<FirebaseFile>> filter(String label) async {
    return firebaseFiles.whereAsync((x) async => await x.hasLabel(label));
  }

  // ------------------ Private methods ------------------ //

  Future<File> _loadThumbnail() async {
    var firstFirebaseFile = (await firebaseFiles).first;
    return await firstFirebaseFile.file;
  }
}
