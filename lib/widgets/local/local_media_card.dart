/*..............................................................................
 . Copyright (c)
 .
 . The local_media_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:52 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/views/media_view.dart';

class LocalMediaCard extends StatefulWidget {
  final AssetEntity media;

  LocalMediaCard(this.media);

  @override
  _LocalMediaCardState createState() => _LocalMediaCardState();
}

class _LocalMediaCardState extends State<LocalMediaCard> {
  Future<Uint8List> futureThumbnail;

  @override
  void initState() {
    futureThumbnail = widget.media.thumbDataWithSize(400, 400);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: futureThumbnail,
      builder: (context, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) return CircularProgressIndicator();

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaView(file: widget.media.file, type: widget.media.type),
              ),
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
                  child: Image.memory(bytes, fit: BoxFit.cover),
                ),
                if (widget.media.type == AssetType.video)
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
            ),
          ),
        );
      },
    );
  }
}
