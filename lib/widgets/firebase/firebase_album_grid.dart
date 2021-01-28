/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_grid.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/28/21 12:03 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/services/gallery_service.dart';
import 'package:photo_store/widgets/firebase/firebase_album_card.dart';
import 'package:photo_store/widgets/future_widget.dart';

class FirebaseAlbumGrid extends StatefulWidget {
  @override
  _FirebaseAlbumGridState createState() => _FirebaseAlbumGridState();
}

class _FirebaseAlbumGridState extends State<FirebaseAlbumGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureWidget<List<FirebaseAlbum>>(
        future: GalleryService.firebaseAlbums,
        builder: (albums) {
          return LiquidPullToRefresh(
            animSpeedFactor: 2,
            springAnimationDurationInMilliseconds: 400,
            showChildOpacityTransition: false,
            onRefresh: () => GalleryService.refreshFirebaseAlbums(),
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(4),
              children: albums.map((album) => FirebaseAlbumCard(album)).toList(),
            ),
          );
        },
      ),
    );
  }
}
