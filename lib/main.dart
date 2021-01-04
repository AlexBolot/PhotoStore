/*..............................................................................
 . Copyright (c)
 .
 . The main.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/4/21 3:27 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/views/grid_view.dart';

void main() {
  runApp(PhotoStore());
}

class PhotoStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String applicationName = 'Photo Store';
    buildSplashScreen() => SplashScreen(
          title: applicationName,
          nextRouteName: PhotoGridView.routeName,
          loadFunctions: [
            () async => await PhotoManager.requestPermission(),
          ],
        );

    return MaterialApp(
      title: applicationName,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => buildSplashScreen(),
        SplashScreen.routeName: (context) => buildSplashScreen(),
        PhotoGridView.routeName: (context) => PhotoGridView()
      },
    );
  }
}
