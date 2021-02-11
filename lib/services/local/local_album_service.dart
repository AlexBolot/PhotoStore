/*..............................................................................
 . Copyright (c)
 .
 . The local_album_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/model/local_album.dart';

class LocalAlbumService {
  static List<LocalAlbum> _albums;

  static Future<List<LocalAlbum>> get albums async => _albums ??= await refresh();

  static Future<List<LocalAlbum>> refresh() async => _albums = await fetchAllAlbums();

  /// Fetches the global list of labels
  static Future<List<LocalAlbum>> fetchAllAlbums() async {
    final assetPathList = await PhotoManager.getAssetPathList();

    List<LocalAlbum> result = [];

    for (AssetPathEntity entity in assetPathList) {
      var assets = await entity.getAssetListRange(start: 0, end: 10000);
      var album = LocalAlbum(name: entity.name, items: assets);
      result.add(album);
    }

    return result;
  }
}
