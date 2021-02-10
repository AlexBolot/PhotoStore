/*..............................................................................
 . Copyright (c)
 .
 . The firebase_media_info.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 10/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/services/firebase/firebase_label_service.dart';

class FirebaseMediaInfo extends StatefulWidget {
  final FirebaseFile firebaseFile;

  const FirebaseMediaInfo({this.firebaseFile});

  @override
  _FirebaseMediaInfoState createState() => _FirebaseMediaInfoState();
}

class _FirebaseMediaInfoState extends State<FirebaseMediaInfo> {
  List<String> currentLabels = [];

  void addLabel(String label) {
    widget.firebaseFile.addLabel(label);
    currentLabels.addNew(label);
  }

  void removeLabel(String label) {
    widget.firebaseFile.removeLabel(label);
    currentLabels.remove(label);
  }

  @override
  void initState() {
    widget.firebaseFile.labels.then((value) {
      setState(() => currentLabels = value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 8,
            children: currentLabels.map((label) {
              return Chip(
                label: Text(label),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() => widget.firebaseFile.removeLabel(label));
                },
              );
            }).toList()
              ..add(
                Chip(
                  label: GestureDetector(
                    child: Icon(Icons.add),
                    onTap: () async {
                      await showAddPopUp();
                      setState(() {});
                    },
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Future<String> showAddPopUp() async {
    var _controller = TextEditingController();

    List<String> getSuggestions(String pattern) {
      List<String> result = [];

      var globalLabels = FirebaseLabelService.globalLabels;

      result.addAll(globalLabels.where((label) => label.contains(pattern)));
      result.removeWhere((label) => currentLabels.contains(label));

      return result..sort();
    }

    Widget suggestionBuilder(_, suggestion) {
      return ListTile(
        title: Text(suggestion),
        visualDensity: VisualDensity.compact,
      );
    }

    void submit([String label]) {
      label ??= _controller.text.trim();

      if (label.isNotEmpty) {
        addLabel(label.toLowerCase());
      }

      Navigator.of(context).pop();
    }

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: submit,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Ajouter',
                  border: InputBorder.none,
                ),
              ),
              hideOnEmpty: true,
              hideOnLoading: true,
              suggestionsCallback: getSuggestions,
              itemBuilder: suggestionBuilder,
              onSuggestionSelected: (suggestion) {
                _controller.text = suggestion;
                setDialogState(() {});
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Annuler'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Valider'),
                onPressed: () => submit(),
              ),
            ],
          );
        });
      },
    );
  }
}
