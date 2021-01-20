/*..............................................................................
 . Copyright (c)
 .
 . The photo_grid_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/19/21 7:26 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/model/album.dart';
import 'package:photo_store/widgets/album_widget.dart';
import 'package:photo_store/widgets/menu_drawer.dart';

class PhotoGridView extends StatefulWidget {
  /// Use this for easier access from Named-Routes navigation
  static const String routeName = "/PhotoGridView";

  /// Text displayed as title of this view (in the appbar)
  final String title;

  const PhotoGridView({this.title = 'PhotoGridView page'});

  @override
  _PhotoGridViewState createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  List<Album> albums = [];

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(8),
        children: albums.map((album) => AlbumWidget(album: album)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchAssets(),
        child: Icon(Icons.refresh),
      ),
    );
  }

  _fetchAssets() async {
    final assetPathList = await PhotoManager.getAssetPathList();

    List<Album> result = [];

    for (AssetPathEntity entity in assetPathList) {
      var assets = await entity.getAssetListRange(start: 0, end: 10000);

      var album = new Album(name: entity.name, items: assets, thumbnail: assets.first);

      result.add(album);
    }

    setState(() => albums = result..sort((a, b) => a.name.compareTo(b.name)));
  }
}
