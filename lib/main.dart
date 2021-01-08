/*..............................................................................
 . Copyright (c)
 .
 . The main.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/8/21 12:17 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/views/photo_grid_view.dart';

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
                () async => await FirebaseAuth.instance.signInAnonymously()
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
