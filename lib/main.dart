/*..............................................................................
 . Copyright (c)
 .
 . The main.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/3/21 11:39 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';

void main() {
  runApp(PhotoStore());
}

class PhotoStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String applicationName = 'Photo Store';
    buildSplashScreen() =>
        SplashScreen(title: applicationName, nextRouteName: '/', // TODO - add route to the main page here,
            loadFunctions: [
              // TODO - add loading function here
            ]);

    return MaterialApp(
      title: applicationName,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => buildSplashScreen(),
        SplashScreen.routeName: (context) => buildSplashScreen(),
        // TODO - add more routes here
      },
    );
  }
}