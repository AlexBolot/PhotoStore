/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_grid.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 5:27 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:photo_store/config.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/services/gallery_service.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/widgets/firebase/firebase_album_card.dart';
import 'package:photo_store/widgets/future_widget.dart';

class FirebaseAlbumGrid extends StatefulWidget {
  final Function(String source) onChangeSource;

  const FirebaseAlbumGrid({this.onChangeSource});

  @override
  _FirebaseAlbumGridState createState() => _FirebaseAlbumGridState();
}

class _FirebaseAlbumGridState extends State<FirebaseAlbumGrid> {
  Future<List<FirebaseAlbum>> futureAlbums;

  @override
  void initState() {
    futureAlbums = GalleryService.firebaseAlbums;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureWidget<List<FirebaseAlbum>>(
        future: futureAlbums,
        builder: (albums) {
          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(4),
            children: albums.map((album) => FirebaseAlbumCard(album)).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => press(() => widget.onChangeSource(Source.localStorage)),
        child: Icon(Icons.flip_outlined),
      ),
    );
  }
}
