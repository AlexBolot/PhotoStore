/*..............................................................................
 . Copyright (c)
 .
 . The Album.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/6/21 6:01 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_manager/photo_manager.dart';

class Album {
  AssetEntity thumbnail;
  List<AssetEntity> items;
  String name;

  get count => items.length;

  Album({this.items, this.name, this.thumbnail});

  Album.empty() {
    this.thumbnail = null;
    this.items = [];
    this.name = '';
  }

  thumbDataWithSize({int width, int height, ThumbFormat format = ThumbFormat.jpeg, int quality = 100}) {
    return thumbnail.thumbDataWithSize(width, height, format: format, quality: quality);
  }
}
