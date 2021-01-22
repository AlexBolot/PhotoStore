/*..............................................................................
 . Copyright (c)
 .
 . The local_album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/22/21 1:30 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_manager/photo_manager.dart';

class LocalAlbum {
  AssetEntity thumbnail;
  List<AssetEntity> items;
  String name;

  get count => items.length;

  LocalAlbum({this.items, this.name, this.thumbnail});

  thumbDataWithSize({int width, int height, ThumbFormat format = ThumbFormat.jpeg, int quality = 100}) {
    return thumbnail.thumbDataWithSize(width, height, format: format, quality: quality);
  }
}
