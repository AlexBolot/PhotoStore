/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_grid.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 16/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/services/firebase/firebase_album_service.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/views/firebase/firebase_filtered_view.dart';
import 'package:photo_store/widgets/firebase/filter_action_button.dart';
import 'package:photo_store/widgets/firebase/firebase_album_card.dart';

class FirebaseAlbumGrid extends StatefulWidget {
  @override
  _FirebaseAlbumGridState createState() => _FirebaseAlbumGridState();
}

class _FirebaseAlbumGridState extends State<FirebaseAlbumGrid> {
  String title = 'Firebase';

  Future<bool> confirmExit() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return _ConfirmExitPopUp(
          onReply: (value) => Navigator.of(context).pop(value),
        );
      },
    );
  }

  List<FirebaseAlbum> handleDragAndDrop(oldIndex, newIndex, albums) {
    switch (DragAndDropBehaviour.current) {
      case DragAndDropBehaviour.reorder:
        return albums = reorder(oldIndex, newIndex, albums);
      case DragAndDropBehaviour.swap:
        return albums = swap(oldIndex, newIndex, albums);
      default:
        return albums;
    }
  }

  List<FirebaseAlbum> reorder(oldIndex, newIndex, albums) {
    int startIndex = albums.indexOf(albums[oldIndex]);
    int endIndex = albums.indexOf(albums[newIndex]);

    if (startIndex > endIndex) {
      for (int i = startIndex; i > endIndex; i--) {
        swap(i, i - 1, albums);
      }
    } else {
      for (int i = startIndex; i < endIndex; i++) {
        swap(i, i + 1, albums);
      }
    }

    return albums;
  }

  List<FirebaseAlbum> swap(oldIndex, newIndex, albums) {
    var tmp = albums[oldIndex];
    albums[oldIndex] = albums[newIndex];
    albums[newIndex] = tmp;

    return albums;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => confirmExit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await FirebaseAlbumService.refresh();
                setState(() {});
              },
            ),
            FilterActionButton(
              onSelect: (value) {
                Navigator.of(context).pushNamed(FirebaseFilteredView.routeName, arguments: {'filter': value});
              },
            ),
          ],
        ),
        body: FutureWidget<List<FirebaseAlbum>>(
          future: FirebaseAlbumService.albums,
          initialData: [],
          builder: (albums) {
            return LiquidPullToRefresh(
              animSpeedFactor: 2,
              springAnimationDurationInMilliseconds: 400,
              showChildOpacityTransition: false,
              onRefresh: () => FirebaseAlbumService.refresh(),
              child: DragAndDropGridView(
                itemCount: albums.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index) => FirebaseAlbumCard(albums[index]),
                feedback: (index) => FirebaseAlbumCard(albums[index], width: 200, height: 200),
                isCustomFeedback: true,
                onWillAccept: (a, b) => true,
                onReorder: (oldIndex, newIndex) {
                  albums = handleDragAndDrop(oldIndex, newIndex, albums);
                  FirebaseAlbumService.saveAlbums(albums);
                  setState(() {});
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ConfirmExitPopUp extends StatelessWidget {
  final ValueChanged<bool> onReply;

  const _ConfirmExitPopUp({this.onReply});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16.0),
      content: Text('Voulez-vous vous déconnecter ?'),
      actions: <Widget>[
        TextButton(child: Text('Non'), onPressed: () => onReply(false)),
        TextButton(child: Text('Oui'), onPressed: () => onReply(true)),
      ],
    );
  }
}
