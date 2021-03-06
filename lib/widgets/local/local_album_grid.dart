/*..............................................................................
 . Copyright (c)
 .
 . The local_album_grid.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 15/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_store/model/local_album.dart';
import 'package:photo_store/services/local/local_album_service.dart';
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
        future: LocalAlbumService.albums,
        builder: (albums) {
          return /*LiquidPullToRefresh(
            animSpeedFactor: 2,
            springAnimationDurationInMilliseconds: 400,
            showChildOpacityTransition: false,
            onRefresh: () => LocalAlbumService.refresh(),
            child: */
              DragAndDropGridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => LocalAlbumCard(album: albums[index]),
            onWillAccept: () => true,
            onReorder: (oldIndex, newIndex) {
              // You can also implement on your own logic on reorderable

              int indexOfFirstItem = albums.indexOf(albums[oldIndex]);
              int indexOfSecondItem = albums.indexOf(albums[newIndex]);

              if (indexOfFirstItem > indexOfSecondItem) {
                for (int i = albums.indexOf(albums[oldIndex]); i > albums.indexOf(albums[newIndex]); i--) {
                  var tmp = albums[i - 1];
                  albums[i - 1] = albums[i];
                  albums[i] = tmp;
                }
              } else {
                for (int i = albums.indexOf(albums[oldIndex]); i < albums.indexOf(albums[newIndex]); i++) {
                  var tmp = albums[i + 1];
                  albums[i + 1] = albums[i];
                  albums[i] = tmp;
                }
              }
              setState(() {});
            },
            //),
          );
        },
      ),
    );
  }
}
