/*..............................................................................
 . Copyright (c)
 .
 . The gallery_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/model/local_album.dart';
import 'package:photo_store/services/firebase/download_service.dart';

class GalleryService {
  static List<LocalAlbum> _localAlbums;
  static List<FirebaseAlbum> _firebaseAlbums;

  static Future<List<LocalAlbum>> get localAlbums async => _localAlbums ??= await _loadLocalAlbums();

  static Future<List<FirebaseAlbum>> get firebaseAlbums async => _firebaseAlbums ??= await _loadFirebaseAlbums();

  static void add(folder) {
    if (folder is LocalAlbum) _localAlbums.add(folder);
    if (folder is FirebaseAlbum) _firebaseAlbums.add(folder);
  }

  static Future<List<FirebaseFile>> filterFirebaseFiles(String filter) async {
    List<FirebaseFile> result = [];

    var albums = await firebaseAlbums;
    for (var album in albums) {
      result.addAll(await album.filter(filter));
    }

    return result;
  }

  static Future<List<FirebaseAlbum>> refreshFirebaseAlbums() async {
    return _firebaseAlbums = await _loadFirebaseAlbums();
  }

  static Future<List<LocalAlbum>> refreshLocalAlbums() async {
    return _localAlbums = await _loadLocalAlbums();
  }

  // ------------------ Private methods ------------------ //

  static Future<List<LocalAlbum>> _loadLocalAlbums() async {
    final assetPathList = await PhotoManager.getAssetPathList();

    List<LocalAlbum> result = [];

    for (AssetPathEntity entity in assetPathList) {
      var assets = await entity.getAssetListRange(start: 0, end: 10000);
      var album = new LocalAlbum(name: entity.name, items: assets);
      result.add(album);
    }

    return result;
  }

  static Future<List<FirebaseAlbum>> _loadFirebaseAlbums() async {
    return await DownloadService.downloadAlbums();
  }
}
