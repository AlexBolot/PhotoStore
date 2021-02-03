/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/28/21 11:28 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/widgets/firebase/firebase_media_card.dart';
import 'package:photo_store/widgets/future_widget.dart';

class FirebaseAlbumView extends StatefulWidget {
  static const String routeName = '/FirebaseAlbumView';

  final FirebaseAlbum album;

  const FirebaseAlbumView(this.album);

  @override
  _FirebaseAlbumViewState createState() => _FirebaseAlbumViewState();
}

class _FirebaseAlbumViewState extends State<FirebaseAlbumView> {
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
      body: FutureWidget<List<FirebaseFile>>(
        future: album.firebaseFiles,
        builder: (files) {
          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            children: files.map((file) => FirebaseMediaCard(file)).toList(),
          );
        },
      ),
    );
  }
}
