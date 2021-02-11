/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 11/02/2021
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

  FirebaseAlbumCard(this.album, {this.onSelected});

  @override
  _FirebaseAlbumCardState createState() => _FirebaseAlbumCardState();
}

class _FirebaseAlbumCardState extends State<FirebaseAlbumCard> {
  Offset tapPosition;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return FutureWidget<File>(
      future: widget.album.thumbnail,
      builder: (thumbnail) {
        return InkWell(
          onTap: () => press(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FirebaseAlbumView(widget.album),
              ),
            );
          }),
          /*onLongPress: () {
            setState(() => selected = true);
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(tapPosition.dx, tapPosition.dy, 100000, 0.0),
              items: [
                PopupMenuItem(child: Text('hello')),
                PopupMenuItem(child: Text('world')),
              ],
            ).then((value) {
              setState(() => selected = false);
            });
          },
          onTapDown: (details) => tapPosition = details.globalPosition,*/
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }
}
