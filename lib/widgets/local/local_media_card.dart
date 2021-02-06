/*..............................................................................
 . Copyright (c)
 .
 . The local_media_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/views/local/local_media_view.dart';

class LocalMediaCard extends StatefulWidget {
  final AssetEntity media;

  LocalMediaCard(this.media);

  @override
  _LocalMediaCardState createState() => _LocalMediaCardState();
}

class _LocalMediaCardState extends State<LocalMediaCard> {
  Future<Uint8List> futureThumbnail;
  Future<File> futureFile;
  AssetType type;

  @override
  void initState() {
    futureThumbnail = widget.media.thumbDataWithSize(400, 400);
    futureFile = widget.media.file;
    type = widget.media.type;
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
                builder: (context) => LocalMediaView(futureFile: futureFile, type: type),
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
            ),
          ),
        );
      },
    );
  }
}
