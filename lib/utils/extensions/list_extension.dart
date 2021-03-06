/*..............................................................................
 . Copyright (c)
 .
 . The list_extension.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/model/firebase_file.dart';

extension ListExtension<T> on List<T> {
  /// Adds a new item only if not null and not already contained
  List<T> addNew(T value) {
    if (value != null && !this.contains(value)) {
      this.add(value);
    }
    return this;
  }

  Future<List> addIfAsync(T value, Future<bool> test(T value)) async {
    if (await test(value)) add(value);
    return this;
  }

  Future<List<dynamic>> mapAsync(Future<dynamic> mapper(T value)) async {
    List<T> result = [];
    await Future.forEach(this, (item) async => result.add(await mapper(item)));
    return result;
  }

  Future<List<T>> whereAsync(Future<bool> test(T item)) async {
    List<T> result = [];
    forEach((item) => result.addIfAsync(item, test));
    return result;
  }

  Future<T> firstWhereAsync(bool test(T element), {Future<T> orElse()}) async {
    var first = this.firstWhere(test, orElse: () => null);
    return first ?? await orElse();
  }
}

extension FirebaseAlbumListExtension on List<FirebaseAlbum> {
  List<FirebaseAlbum> ordered() => this..sort((a, b) => a.index.compareTo(b.index));

  FirebaseAlbum findByName(String albumName) => this.firstWhere((album) => album.name == albumName);

  Future<List<FirebaseFile>> filter(String label) async {
    List<FirebaseFile> result = [];
    await Future.forEach(this, (FirebaseAlbum album) async => result.addAll(await album.filter(label)));
    return result;
  }

  List<Map<String, dynamic>> mapAll() => this.map((album) => album.toMap()).toList();

  String printable() => '${this.map((album) => '${album.name}::${album.index}')}';
}
