/*..............................................................................
 . Copyright (c)
 .
 . The media_widget.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/6/21 6:01 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/views/media_view.dart';

class MediaWidget extends StatelessWidget {
  final AssetEntity media;

  const MediaWidget({@required this.media});

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: media.thumbDataWithSize(400, 400),
      builder: (_, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) return CircularProgressIndicator();

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MediaView(file: media.file, type: media.type),
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
                if (media.type == AssetType.video)
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
