/*..............................................................................
 . Copyright (c)
 .
 . The filter_action_button.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 09/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:photo_store/services/firebase/firebase_label_service.dart';

class FilterActionButton extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const FilterActionButton({this.onSelect});

  @override
  Widget build(BuildContext context) {
    var globalLabels = FirebaseLabelService.globalLabels;
    return IconButton(
      icon: Icon(Icons.filter_alt),
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Choisir un filtre'),
              titlePadding: EdgeInsets.all(16),
              contentPadding: EdgeInsets.all(0),
              content: Container(
                height: 450,
                width: 150,
                child: ListView.builder(
                  itemCount: globalLabels.length,
                  itemBuilder: (context, index) {
                    var label = globalLabels[index];
                    return GestureDetector(
                      onTap: () => onSelect(label),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(label),
                        ),
                        elevation: 4,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
