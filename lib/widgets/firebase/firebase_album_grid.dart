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
import 'package:photo_store/services/firebase/firebase_label_service.dart';
import 'package:photo_store/services/gallery_service.dart';
import 'package:photo_store/widgets/firebase/firebase_album_card.dart';

class FirebaseAlbumGrid extends StatefulWidget {
  @override
  _FirebaseAlbumGridState createState() => _FirebaseAlbumGridState();
}

class _FirebaseAlbumGridState extends State<FirebaseAlbumGrid> {
  String title = 'Firebase';
  String filter = '';

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

  Future selectFilter() async {
    filter = await showDialog<String>(
      context: context,
      builder: (context) {
        return _SelectFilterPopUp(
          onSelect: (label) => Navigator.of(context).pop(label),
        );
      },
    );

    setState(() {});
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
              icon: Icon(Icons.filter_alt),
              onPressed: () async {
                print(await selectFilter());
              },
            )
          ],
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

class _SelectFilterPopUp extends StatelessWidget {
  final ValueChanged<String> onSelect;
  final List<String> globalLabels = FirebaseLabelService.getGlobalLabels();

  _SelectFilterPopUp({this.onSelect});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choisir un filtre'),
      titlePadding: EdgeInsets.all(16),
      contentPadding: EdgeInsets.all(0),
      content: Container(
        height: 450,
        width: 150,
        child: ListView.builder(
          itemCount: globalLabels.length,
          itemBuilder: (context, index) {
            var label = globalLabels[index];
            return GestureDetector(
              onTap: () => onSelect(label),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(label),
                ),
                elevation: 4,
              ),
            );
          },
        ),
      ),
    );
  }
}
