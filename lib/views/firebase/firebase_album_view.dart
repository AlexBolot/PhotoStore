/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/widgets/firebase/firebase_media_card.dart';

class FirebaseAlbumView extends StatefulWidget {
  static const String routeName = '/FirebaseAlbumView';

  final FirebaseAlbum album;

  const FirebaseAlbumView(this.album);

  @override
  _FirebaseAlbumViewState createState() => _FirebaseAlbumViewState();
}

class _FirebaseAlbumViewState extends State<FirebaseAlbumView> {
  @override
  Widget build(BuildContext context) {
    var album = widget.album;

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        children: album.firebaseFiles.map((file) => FirebaseMediaCard(file)).toList(),
      ),
    );
  }
}
