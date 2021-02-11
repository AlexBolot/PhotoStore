/*..............................................................................
 . Copyright (c)
 .  
 . The firebase_album_service.dart class was created by : Alex Bolot and Pierre Bolot
 .  
 . As part of the PhotoStore project
 .  
 . Last modified : 11/02/2021
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

  /// Forces to reload the list of all albums and files
  static Future<List<FirebaseAlbum>> refresh() async => _albums = await fetchAllAlbums();

  /// Returns all firebaseFiles containing a given label
  static Future<List<FirebaseFile>> filter(String label) async => _albums.mapAsync((album) => album.filter(label));

  /// Load the list of all albums and files from firestore
  static Future<List<FirebaseAlbum>> fetchAllAlbums() async {
    var document = await getAlbumsDocument();
    List<dynamic> albumsList = await document.getData(FirebaseFields.albums, []);

    var albums = albumsList.map((data) => FirebaseAlbum.fromMap(data)).toList();
    var albumNames = albums.map((album) => album.name).join((', '));

    logFetch('Loaded ${albums.length} albums from Firebase :: $albumNames');
    return albums;
  }

  /// Adds a firebaseFile to a remote firestore album
  static Future<void> addToAlbum(SavePath savePath) async {
    var albumName = savePath.directory;
    var fileName = savePath.fileName;

    bool sameName(FirebaseAlbum album) => album.name == albumName;
    Map albumToJson(FirebaseAlbum album) => album.toMap();

    if (_albums.contains(albumName)) {
      _albums.firstWhere(sameName).addFile(fileName);
    } else {
      _albums.add(await createAlbum(albumName)
        ..addFile(fileName));
    }

    var document = await getAlbumsDocument();
    await document.update({FirebaseFields.albums: _albums.map(albumToJson).toList()});

    logUpdate('Saved new file in $albumName :: $fileName');
  }

  static Future<FirebaseAlbum> createAlbum(String albumName) async {
    var document = await getAlbumsDocument();
    var lastIndex = await document.getData(FirebaseFields.lastAlbumIndex, 0);

    var newIndex = lastIndex + 1;

    await document.update({FirebaseFields.lastAlbumIndex: newIndex});

    return FirebaseAlbum(albumName, newIndex, []);
  }
}
