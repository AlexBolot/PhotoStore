/*..............................................................................
 . Copyright (c)
 .
 . The album_widget.dart class was created by : Alex Bolot and Pierre Bolot
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
import 'package:photo_store/model/Album.dart';
import 'package:photo_store/views/album_view.dart';

class AlbumWidget extends StatelessWidget {
  final Album album;

  const AlbumWidget({@required this.album});

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: album.thumbDataWithSize(width: 400, height: 400),
      builder: (_, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) return CircularProgressIndicator();

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AlbumView(album: album),
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
                    "${album.name} (${album.count})",
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

/*
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
 */
