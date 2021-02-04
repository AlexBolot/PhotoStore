/*..............................................................................
 . Copyright (c)
 .
 . The extensions.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 2/4/21 12:14 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/model/firebase_file.dart';

extension Folders on ListResult {
  forEach(Function(Reference folder) function) => this.prefixes.forEach(function);

  List<String> get fileNames => this.prefixes.map((ref) => ref.name).toList();

  List<FirebaseAlbum> toFirebaseAlbums() {
    return this.prefixes.map((ref) => FirebaseAlbum(ref)).toList();
  }

  List<FirebaseFile> toFirebaseFile() {
    return this.items.map((ref) => FirebaseFile(ref)).toList();
  }
}

extension Count<E> on Iterable<E> {
  int count(bool test(E element)) => this.where(test).length;
}

extension EuropeanFormat on DateTime {
  String toEuropeanFormat() {
    var day = '${this.day < 10 ? '0' : ''}${this.day}';
    var month = '${this.month < 10 ? '0' : ''}${this.month}';

    var hour = '${this.hour < 10 ? '0' : ''}${this.hour}';
    var min = '${this.minute < 10 ? '0' : ''}${this.minute}';
    var sec = '${this.second < 10 ? '0' : ''}${this.second}';

    return '{$day/$month/$year $hour:$min:$sec}';
  }
}

extension GetOrDefault on Map<String, dynamic> {
  dynamic get(String key, {orDefault}) {
    return this.containsKey(key) ? this[key] : orDefault;
  }
}
