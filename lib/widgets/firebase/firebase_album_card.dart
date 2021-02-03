/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 2/3/21 6:34 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_store/global.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/views/firebase_album_view.dart';
import 'package:photo_store/widgets/future_widget.dart';

class FirebaseAlbumCard extends StatelessWidget {
  final FirebaseAlbum album;

  FirebaseAlbumCard(this.album);

  @override
  Widget build(BuildContext context) {
    return FutureWidget<File>(
      future: album.thumbnail,
      builder: (thumbnail) {
        return InkWell(
          onTap: () => press(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FirebaseAlbumView(album),
              ),
            );
          }),
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
                    future: album.count,
                    initialData: -1,
                    builder: (count) {
                      return Text(
                        "${album.name} ($count)",
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

/*

CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: downloadUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return CircularProgressIndicator(value: downloadProgress.progress);
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
 */
