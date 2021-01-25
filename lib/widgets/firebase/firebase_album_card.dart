/*..............................................................................
 . Copyright (c)
 .
 . The firebase_album_card.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:52 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/model/firebase_album.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/views/firebase_album_view.dart';

class FirebaseAlbumCard extends StatelessWidget {
  final FirebaseAlbum album;
  final Future<FirebaseFile> futureFile;

  FirebaseAlbumCard(this.album) : futureFile = album.thumbnail;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureFile,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();

        FirebaseFile thumbnail = snapshot.data;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FirebaseAlbumView(album),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FirebaseImage(thumbnail.location),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.black87,
                  width: double.maxFinite,
                  child: FutureBuilder(
                    future: album.count,
                    initialData: -1,
                    builder: (context, snapshot) {
                      var count = snapshot.data;

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
