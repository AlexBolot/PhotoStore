/*..............................................................................
 . Copyright (c)
 .
 . The photo_widget.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/4/21 3:51 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoWidget extends StatelessWidget {
  final AssetEntity asset;

  const PhotoWidget({@required this.asset});

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: asset.thumbDataWithSize(400, 400),
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return CircularProgressIndicator();
        // If there's data, display it as an image
        return Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.memory(bytes, fit: BoxFit.cover),
        );
      },
    );
  }
}
