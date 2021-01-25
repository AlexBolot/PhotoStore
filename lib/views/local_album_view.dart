/*..............................................................................
 . Copyright (c)
 .
 . The local_album_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:45 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/model/local_album.dart';
import 'package:photo_store/widgets/local/local_media_card.dart';

class LocalAlbumView extends StatefulWidget {
  static const String routeName = '/LocalAlbumView';

  final LocalAlbum album;

  const LocalAlbumView({this.album});

  @override
  _LocalAlbumViewState createState() => _LocalAlbumViewState();
}

class _LocalAlbumViewState extends State<LocalAlbumView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var album = widget.album;

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        children: album.items.map((item) => LocalMediaCard(item)).toList(),
      ),
    );
  }
}
