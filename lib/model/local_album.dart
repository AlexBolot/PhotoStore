/*..............................................................................
 . Copyright (c)
 .
 . The local_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:52 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class LocalAlbum {
  AssetEntity _thumbnail;
  List<AssetEntity> items;
  String name;

  LocalAlbum({this.items, this.name}) : this._thumbnail = items.first;

  get count => items.length;

  Future<Uint8List> get thumbnail => _thumbnail.thumbDataWithSize(400, 400);
}
