/*..............................................................................
 . Copyright (c)
 .
 . The photo_grid_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 5:27 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/widgets/firebase/firebase_album_grid.dart';
import 'package:photo_store/widgets/future_widget.dart';
import 'package:photo_store/widgets/local/local_album_grid.dart';
import 'package:photo_store/widgets/menu_drawer.dart';

class PhotoGridView extends StatefulWidget {
  static const String routeName = "/PhotoGridView";

  @override
  _PhotoGridViewState createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  Future<String> futurePreference;

  @override
  void initState() {
    futurePreference = getPreference(Preference.source, orDefault: Source.localStorage);
    super.initState();
  }

  changeSource(String source) {
    setState(() {
      setPreference(Preference.source, source);
      futurePreference = Future.value(source);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureWidget<String>(
      future: futurePreference,
      initialData: Source.firebaseStorage,
      builder: (source) {
        return Scaffold(
          drawer: MenuDrawer(onChangeSource: changeSource),
          appBar: AppBar(title: Text(source)),
          body: Builder(
            builder: (context) {
              switch (source) {
                case Source.firebaseStorage:
                  return FirebaseAlbumGrid(onChangeSource: changeSource);
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
