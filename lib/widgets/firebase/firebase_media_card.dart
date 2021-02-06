/*..............................................................................
 . Copyright (c)
 .
 . The firebase_media_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/views/firebase/firebase_media_view.dart';

class FirebaseMediaCard extends StatefulWidget {
  final FirebaseFile firebaseFile;

  const FirebaseMediaCard(this.firebaseFile);

  @override
  _FirebaseMediaCardState createState() => _FirebaseMediaCardState();
}

class _FirebaseMediaCardState extends State<FirebaseMediaCard> {
  Future<File> futureFile;
  AssetType type;

  @override
  void initState() {
    futureFile = widget.firebaseFile.file;
    type = widget.firebaseFile.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FirebaseMediaView(firebaseFile: widget.firebaseFile, type: type)),
        );
      },
      child: Card(
        margin: EdgeInsets.all(2),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: FutureWidget<File>(
            future: futureFile,
            builder: (file) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Image(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (type == AssetType.video)
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
                    ),
                ],
              );
            }),
      ),
    );
  }
}
