/*..............................................................................
 . Copyright (c)
 .  
 . The firebase_album_service.dart class was created by : Alex Bolot and Pierre Bolot
 .  
 . As part of the PhotoStore project
 .  
 . Last modified : 09/02/2021
 .  
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseAlbumService {
  static List<FirebaseAlbum> _albums;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String get _userName => AccountService.currentAccount.name;

  /// Returns the in-memory albums or loads from firestore if null
  static Future<List<FirebaseAlbum>> get albums async => _albums ??= await fetchAllAlbums();

  /// Forces to reload the list of all albums and files
  static Future<List<FirebaseAlbum>> refresh() async => _albums = await fetchAllAlbums();

  /// Returns all firebaseFiles containing a given label
  static Future<List<FirebaseFile>> filter(String label) async => _albums.mapAsync((album) => album.filter(label));

  /// Load the list of all albums and files from firestore
  static Future<List<FirebaseAlbum>> fetchAllAlbums() async {
    var albumsMap = await _getAlbumsMap();

    logFetch('Loaded ${albumsMap.length} albums from Firebase :: ${albumsMap.keys.join(', ')}');
    return albumsMap.keys.map((key) => FirebaseAlbum(key, albumsMap[key])).toList();
  }

  /// Adds a firebaseFile to a remote firestore album
  static Future<void> addToAlbum(SavePath savePath) async {
    var albumsMap = await _getAlbumsMap();
    albumsMap.putIfAbsent(savePath.directory, () => []);
    albumsMap[savePath.directory].add(savePath.fileName);

    _getAlbumsDocument().upsert(albumsMap);

    logUpdate('Saved new file in ${savePath.directory} :: ${savePath.fileName}');
  }

  // ------------------ Private methods ------------------ //

  static DocumentReference _getAlbumsDocument() => _firestore.collection('Autre').doc('Albums_$_userName');

  static Future<Map<String, List<String>>> _getAlbumsMap() async {
    DocumentReference document = _getAlbumsDocument();
    Map<String, dynamic> content = (await document.get()).data();

    Map<String, List<String>> result = {};
    content.forEach((key, value) => result.putIfAbsent(key, () => value.cast<String>()));

    return result;
  }
}
