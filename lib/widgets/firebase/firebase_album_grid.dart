/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_grid.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/services/gallery_service.dart';
import 'package:photo_store/views/firebase/firebase_filtered_view.dart';
import 'package:photo_store/widgets/firebase/filter_action_button.dart';
import 'package:photo_store/widgets/firebase/firebase_album_card.dart';

class FirebaseAlbumGrid extends StatefulWidget {
  @override
  _FirebaseAlbumGridState createState() => _FirebaseAlbumGridState();
}

class _FirebaseAlbumGridState extends State<FirebaseAlbumGrid> {
  String title = 'Firebase';

  @override
  void initState() {
    super.initState();
  }

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

  changeFilter(String filter) {
    var newPage = FirebaseFilteredView(filter: filter, onChangeFilter: (value) => changeFilter(value));

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => newPage));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => confirmExit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [FilterActionButton(onSelect: (value) => changeFilter(value))],
        ),
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
