/*..............................................................................
 . Copyright (c)
 .
 . The firebase_filtered_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/services/firebase/firebase_album_service.dart';
import 'package:photo_store/widgets/firebase/filter_action_button.dart';
import 'package:photo_store/widgets/firebase/firebase_media_card.dart';

class FirebaseFilteredView extends StatefulWidget {
  static const String routeName = '/FirebaseFilteredView';

  final ValueChanged<String> onChangeFilter;
  final String filter;
  final String title;

  const FirebaseFilteredView({this.title, this.filter, this.onChangeFilter});

  @override
  _FirebaseFilteredViewState createState() => _FirebaseFilteredViewState();
}

class _FirebaseFilteredViewState extends State<FirebaseFilteredView> {
  changeFilter(String newFilter) {
    var newPage = FirebaseFilteredView(filter: newFilter);
    var newPageRoute = MaterialPageRoute(builder: (_) => newPage);
    Navigator.of(context).pushReplacement(newPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flitre : ${widget.filter}'),
        actions: [FilterActionButton(onSelect: (value) => widget.onChangeFilter(value))],
      ),
      body: FutureWidget<List<FirebaseFile>>(
        future: FirebaseAlbumService.filter(widget.filter),
        builder: (files) {
          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            children: files.map((file) => FirebaseMediaCard(file)).toList(),
          );
        },
      ),
    );
  }
}
