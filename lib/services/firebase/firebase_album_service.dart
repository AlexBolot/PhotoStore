/*..............................................................................
 . Copyright (c)
 .  
 . The firebase_album_service.dart class was created by : Alex Bolot and Pierre Bolot
 .  
 . As part of the PhotoStore project
 .  
 . Last modified : 14/02/2021
 .  
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/utils/extensions.dart';
import 'package:photo_store/utils/firebase_accessors.dart';

class FirebaseAlbumService {
  static List<FirebaseAlbum> _albums;

  /// Returns the in-memory albums or loads from firestore if null
  static Future<List<FirebaseAlbum>> get albums async => _albums ??= await fetchAllAlbums();

  static set albums(newList) => _albums = List.from(newList);

  /// Forces to reload the list of all albums and files
  static Future<List<FirebaseAlbum>> refresh() async => _albums = await fetchAllAlbums();

  /// Returns all firebaseFiles containing a given label
  static Future<List<FirebaseFile>> filter(String label) async => _albums.filter(label);

  /// Load the list of all albums and files from firestore
  static Future<List<FirebaseAlbum>> fetchAllAlbums() async {
    var document = await getAlbumsDocument();
    List<dynamic> albumsList = await document.getData(FirebaseFields.albums, []);

    var albums = albumsList.map((data) => FirebaseAlbum.fromMap(data)).toList();
    var albumNames = albums.map((album) => album.name).join((', '));

    logFetch('Loaded ${albums.length} albums from Firebase :: $albumNames');
    return albums.ordered();
  }

  /// Adds a firebaseFile to a remote firestore album
  static Future<void> addToAlbum(SavePath savePath) async {
    var albumName = savePath.directory;
    var fileName = savePath.fileName;

    if (_albums.contains(albumName)) {
      _albums.findByName(albumName).addFile(fileName);
    } else {
      var newAlbum = await createAlbum(albumName);
      newAlbum.addFile(fileName);
      _albums.add(newAlbum);
    }

    await saveAlbums();
    logUpdate('Saved new file in $albumName :: $fileName');
  }

  static Future<FirebaseAlbum> createAlbum(String albumName) async {
    var document = await getAlbumsDocument();
    var albumCounts = await document.getData(FirebaseFields.albumsCount, 0);

    await document.update({FirebaseFields.albumsCount: albumCounts + 1});
    var newAlbum = FirebaseAlbum(albumName, albumCounts + 1, []);

    logDebug('Created new Album :: ${newAlbum.name}');

    return newAlbum;
  }

  static Future<void> saveAlbums() async {
    var document = await getAlbumsDocument();
    _updateIndexes();
    await document.update({FirebaseFields.albums: _albums.mapAll()});
  }

  static void _updateIndexes() {
    _albums
      ..forEach((album) => album.index = _albums.indexOf(album))
      ..ordered();
  }
}
