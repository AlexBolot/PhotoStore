/*..............................................................................
 . Copyright (c)
 .
 . The local_album_grid.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:52 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/config.dart';
import 'package:photo_store/model/local_album.dart';
import 'package:photo_store/services/gallery_service.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/widgets/local/local_album_card.dart';

class LocalAlbumGrid extends StatefulWidget {
  static const String routeName = "/LocalAlbumGrid";

  final Function(String source) onChangeSource;

  const LocalAlbumGrid({this.onChangeSource});

  @override
  _LocalAlbumGridState createState() => _LocalAlbumGridState();
}

class _LocalAlbumGridState extends State<LocalAlbumGrid> {
  Future<List<LocalAlbum>> futureAlbums;

  @override
  void initState() {
    futureAlbums = GalleryService.localAlbums;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureAlbums,
        builder: (context, snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();

          List<LocalAlbum> albums = snapshot.data;

          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(8),
            children: albums.map((album) => LocalAlbumCard(album: album)).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () => press(() => widget.onChangeSource(Source.firebaseStorage)),
        child: Icon(Icons.flip_outlined),
      ),
    );
  }
}
