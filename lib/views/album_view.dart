/*..............................................................................
 . Copyright (c)
 .
 . The album_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/6/21 6:01 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/model/Album.dart';
import 'package:photo_store/widgets/media_widget.dart';

class AlbumView extends StatefulWidget {
  /// Use this for easier access from Named-Routes navigation
  static const String routeName = "/PhotoGridView";

  final Album album;

  const AlbumView({this.album});

  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var album = widget.album ?? Album.empty();

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        children: album.items.map((item) => MediaWidget(media: item)).toList(),
      ),
    );
  }
}
