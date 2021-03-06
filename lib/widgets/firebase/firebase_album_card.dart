/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 15/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/utils/global.dart';
import 'package:photo_store/views/firebase/firebase_album_view.dart';

class FirebaseAlbumCard extends StatefulWidget {
  final FirebaseAlbum album;
  final ValueChanged onSelected;
  final double width;
  final double height;

  FirebaseAlbumCard(this.album, {this.onSelected, this.width = 400, this.height = 400});

  @override
  _FirebaseAlbumCardState createState() => _FirebaseAlbumCardState();
}

class _FirebaseAlbumCardState extends State<FirebaseAlbumCard> {
  Offset tapPosition;
  bool selected = false;

  onTap() {
    return press(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FirebaseAlbumView(widget.album)),
      );
    });
  }

  onLongPress() {
    setState(() => selected = true);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(tapPosition.dx, tapPosition.dy, 100000, 0.0),
      items: [
        PopupMenuItem(child: Text('hello')),
        PopupMenuItem(child: Text('world')),
      ],
    ).then((value) => setState(() => selected = false));
  }

  onTapDown(details) => tapPosition = details.globalPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: FutureWidget<File>(
        future: widget.album.thumbnail,
        builder: (thumbnail) {
          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: GestureDetector(
              onTap: () => press(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FirebaseAlbumView(widget.album),
                  ),
                );
              }),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.black87,
                    width: double.maxFinite,
                    child: FutureWidget<int>(
                      future: widget.album.count,
                      initialData: -1,
                      builder: (count) {
                        return Text(
                          "${widget.album.name} ($count)",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
