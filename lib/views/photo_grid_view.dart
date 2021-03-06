/*..............................................................................
 . Copyright (c)
 .
 . The photo_grid_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 13/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/widgets/firebase/firebase_album_grid.dart';
import 'package:photo_store/widgets/local/local_album_grid.dart';
import 'package:photo_store/widgets/menu_drawer.dart';

class PhotoGridView extends StatefulWidget {
  static const String routeName = "/PhotoGridView";

  @override
  _PhotoGridViewState createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(updateParent: () => setState(() {})),
      body: SwitchWidget(
        value: Source.current,
        cases: {
          Source.firebaseStorage: FirebaseAlbumGrid(),
          Source.localStorage: LocalAlbumGrid(),
        },
      ),
    );
  }
}
