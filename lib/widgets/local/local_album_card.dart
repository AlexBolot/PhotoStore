/*..............................................................................
 . Copyright (c)
 .
 . The local_album_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 5:27 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/model/local_album.dart';
import 'package:photo_store/views/local_album_view.dart';
import 'package:photo_store/widgets/future_widget.dart';

class LocalAlbumCard extends StatefulWidget {
  final LocalAlbum album;

  const LocalAlbumCard({@required this.album});

  @override
  _LocalAlbumCardState createState() => _LocalAlbumCardState();
}

class _LocalAlbumCardState extends State<LocalAlbumCard> {
  Future<Uint8List> futureThumbnail;

  @override
  void initState() {
    futureThumbnail = widget.album.thumbnail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureWidget<Uint8List>(
      future: futureThumbnail,
      builder: (bytes) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocalAlbumView(album: widget.album),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(bytes),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.black87,
                  width: double.maxFinite,
                  child: Text(
                    "${widget.album.name} (${widget.album.count})",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
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