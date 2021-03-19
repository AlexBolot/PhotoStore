/*..............................................................................
 . Copyright (c)
 .
 . The drop_down.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 19/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:photo_store/utils/extensions.dart';

class DropDownList extends StatefulWidget {
  final List<String> values;
  final String value;
  final ValueChanged<String> onSelect;

  const DropDownList({this.values, this.value, this.onSelect});

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  GlobalKey _dropdownButtonKey;

  buildItems() {
    return widget.values.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text(
          value.toFirstUpper(),
        ),
      );
    }).toList();
  }

  buildSelectedItems() {
    return widget.values.map((value) {
      return Center(
        child: Text(
          value.toFirstUpper(),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropdownButton(
          key: _dropdownButtonKey,
          underline: Container(),
          elevation: 2,
          value: widget.value,
          items: buildItems(),
          onChanged: widget.onSelect,
          isDense: true,
          selectedItemBuilder: (_) => buildSelectedItems(),
        ),
      ],
    );
  }
}
