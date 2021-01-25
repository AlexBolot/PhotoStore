/*..............................................................................
 . Copyright (c)
 .
 . The photo_grid_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 9:09 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/widgets/firebase/firebase_global_grid.dart';
import 'package:photo_store/widgets/local/local_album_grid.dart';
import 'package:photo_store/widgets/menu_drawer.dart';

class PhotoGridView extends StatefulWidget {
  static const String routeName = "/PhotoGridView";

  @override
  _PhotoGridViewState createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  @override
  void initState() {
    super.initState();
  }

  changeSource(String source) {
    setState(() {
      setPreference(Preference.source, source);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPreference(Preference.source, orDefault: Source.localStorage),
      initialData: Source.firebaseStorage,
      builder: (context, source) {
        return Scaffold(
          drawer: MenuDrawer(onChangeSource: changeSource),
          appBar: AppBar(title: Text(source.data ?? '')),
          body: Builder(
            builder: (context) {
              if (!source.hasData) return CircularProgressIndicator();

              switch (source.data) {
                case Source.firebaseStorage:
                  return FirebaseGlobalGrid(onChangeSource: changeSource);
                case Source.localStorage:
                  return LocalAlbumGrid(onChangeSource: changeSource);
                default:
                  return CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }
}
