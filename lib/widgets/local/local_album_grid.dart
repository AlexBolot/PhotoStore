/*..............................................................................
 . Copyright (c)
 .
 . The local_album_grid.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/28/21 12:03 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:photo_store/model/local_album.dart';
import 'package:photo_store/services/gallery_service.dart';
import 'package:photo_store/widgets/future_widget.dart';
import 'package:photo_store/widgets/local/local_album_card.dart';

class LocalAlbumGrid extends StatefulWidget {
  @override
  _LocalAlbumGridState createState() => _LocalAlbumGridState();
}

class _LocalAlbumGridState extends State<LocalAlbumGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureWidget<List<LocalAlbum>>(
        future: GalleryService.localAlbums,
        builder: (albums) {
          return LiquidPullToRefresh(
            animSpeedFactor: 2,
            springAnimationDurationInMilliseconds: 400,
            showChildOpacityTransition: false,
            onRefresh: () => GalleryService.refreshLocalAlbums(),
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(8),
              children: albums.map((album) => LocalAlbumCard(album: album)).toList(),
            ),
          );
        },
      ),
    );
  }
}
