/*..............................................................................
 . Copyright (c)
 .
 . The album_widget.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/4/21 5:08 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/views/media_view.dart';

class AlbumWidget extends StatelessWidget {
  final AssetEntity asset;

  const AlbumWidget({@required this.asset});

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: asset.thumbDataWithSize(400, 400),
      builder: (_, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) return CircularProgressIndicator();

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MediaView(file: asset.file, type: asset.type),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.memory(bytes, fit: BoxFit.cover),
                ),
                if (asset.type == AssetType.video)
                  Center(
                    child: Container(
                      color: Colors.blue,
                      child: Icon(Icons.play_arrow, color: Colors.white),
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
