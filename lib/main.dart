/*..............................................................................
 . Copyright (c)
 .
 . The main.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:42 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:logging/logging.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/views/login_view.dart';
import 'package:photo_store/views/photo_grid_view.dart';

main() async {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((record) {
    print('=== ${record.loggerName}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  logger.info('Started App');

  runApp(PhotoStore());
}

class PhotoStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String applicationName = 'Photo Store';

    return MaterialApp(
      title: applicationName,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginView(title: applicationName),
        LoginView.routeName: (context) => LoginView(title: applicationName),
        SplashScreen.routeName: (context) => buildSplashScreen(applicationName),
        PhotoGridView.routeName: (context) => PhotoGridView(),
      },
    );
  }
}

buildSplashScreen(String title) {
  return SplashScreen(
    title: title,
    nextRouteName: PhotoGridView.routeName,
    loadFunctions: [
      () async => await PhotoManager.requestPermission(),
      () async => await AccountService.loginToFirebase().then((result) => logResult('Firebase login', result)),
    ],
  );
}
