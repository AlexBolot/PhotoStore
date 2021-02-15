/*..............................................................................
 . Copyright (c)
 .
 . The extensions.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 15/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/services/logging_service.dart';

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

extension MapExtension<A, B> on Map<A, B> {
  /// Returns [orDefault] if the Map doesn't contain [key] or if the value is null
  B get(A key, {B orDefault}) {
    return this.containsKey(key) ? this[key] ?? orDefault : orDefault;
  }

  B add(A key, B value) => this.putIfAbsent(key, () => value);
}

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

extension FirebaseAlbumList on List<FirebaseAlbum> {
  List<FirebaseAlbum> ordered() => this..sort((a, b) => a.index.compareTo(b.index));

  FirebaseAlbum findByName(String albumName) => this.firstWhere((album) => album.name == albumName);

  Future<List<FirebaseFile>> filter(String label) async {
    List<FirebaseFile> result = [];
    await Future.forEach(this, (FirebaseAlbum album) async => result.addAll(await album.filter(label)));
    return result;
  }

  List<Map<String, dynamic>> mapAll() => this.map((album) => album.toMap()).toList();

  void print() {
    logDebug('albums -> ${this.map((album) => '${album.name}::${album.index}')}');
  }
}

extension Exists on DocumentReference {
  Future<bool> get exists async => (await this.get()).exists;

  Future<bool> get notExists async => !await this.exists;

  Future createEmpty() async => await this.set({});

  Future<dynamic> getData([String field, dynamic orDefault]) async => (await getMap()).get(field, orDefault: orDefault);

  Future<Map<String, dynamic>> getMap() async => (await this.get()).data();
}
