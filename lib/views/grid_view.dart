/*..............................................................................
 . Copyright (c)
 .
 . The grid_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/4/21 3:49 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/widgets/album_widget.dart';

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
  List<AssetEntity> assets = [];

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(8),
        children: assets.map((asset) => AlbumWidget(asset: asset)).toList(),
      ),
    );
  }

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(start: 0, end: 15);

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }
}
