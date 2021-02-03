/*..............................................................................
 . Copyright (c)
 .
 . The photo_grid_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/28/21 12:03 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String source = '';
  final controller = PageController(initialPage: 1);

  @override
  void initState() {
    initSource();
    super.initState();
  }

  initSource() async {
    source = await getPreference(Preference.source, orDefault: Source.localStorage);
    controller.jumpToPage(Source.indexOf(source));
    setState(() {});
  }

  changeSource(int index) {
    setPreference(Preference.source, Source.fromIndex(index));
    controller.jumpToPage(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(onChange: () => setState(() {})),
      appBar: AppBar(title: Text(source)),
      body: PageView(
        onPageChanged: (index) => changeSource(index),
        controller: controller,
        children: [
          LocalAlbumGrid(),
          FirebaseAlbumGrid(),
        ],
      ),
    );
  }
}
