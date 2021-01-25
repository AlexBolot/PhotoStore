/*..............................................................................
 . Copyright (c)
 .
 . The firebase_media_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:52 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/views/firebase_media_view.dart';

class FirebaseMediaCard extends StatefulWidget {
  final FirebaseFile firebaseFile;

  const FirebaseMediaCard(this.firebaseFile);

  @override
  _FirebaseMediaCardState createState() => _FirebaseMediaCardState();
}

class _FirebaseMediaCardState extends State<FirebaseMediaCard> {
  Future<File> futureFile;

  @override
  void initState() {
    futureFile = widget.firebaseFile.file;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var type = widget.firebaseFile.type;
    var location = widget.firebaseFile.location;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FirebaseMediaView(location: location, type: type)),
        );
      },
      child: Card(
        margin: EdgeInsets.all(2),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image(
                image: FirebaseImage(location),
                fit: BoxFit.cover,
              ),
            ),
            /*if (file.type == AssetType.video)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 60.0,
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
