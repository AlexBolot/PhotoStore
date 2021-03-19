/*..............................................................................
 . Copyright (c)
 .
 . The menu_drawer.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 19/03/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_store/services/cache_service.dart';
import 'package:photo_store/services/firebase/upload_service.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/utils/global.dart';
import 'package:photo_store/widgets/drop_down.dart';

class MenuDrawer extends StatefulWidget {
  final Function updateParent;

  const MenuDrawer({this.updateParent});

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  void initState() {
    super.initState();
  }

  refreshDrawerAndParent() {
    widget.updateParent();
    setState(() {});
  }

  changeSource(String value) {
    Source.current = value;
    refreshDrawerAndParent();
  }

  changeDragDropBehaviour(String value) {
    DragAndDropBehaviour.current = value;
    refreshDrawerAndParent();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "Paramètres de l'application",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          DropDownItem(
            title: 'Source des photos',
            values: Source.values,
            selectedValue: Source.current,
            onSelect: (value) => changeSource(value),
          ),
          DropDownItem(
            title: 'Drag and Drop',
            values: DragAndDropBehaviour.values,
            selectedValue: DragAndDropBehaviour.current,
            onSelect: (value) => changeDragDropBehaviour(value),
          ),
          SimpleItem(
            icon: Icons.upload_sharp,
            text: 'Upload with labels',
            onPress: () => UploadService.uploadWithLabels(),
          ),
          SimpleItem(
            icon: Icons.delete,
            text: 'Libérer de l\'espace',
            onPress: () => CacheService.freeSpaceOnDevice(Duration()),
          ),
        ],
      ),
    );
  }
}

class SimpleItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPress;
  final bool selected;

  const SimpleItem({this.icon, this.text = '', this.onPress, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon),
      title: Text(text),
      onTap: () => press(onPress),
      selected: selected,
    );
  }
}

class RadioItem extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String value;
  final String groupValue;
  final Function onTap;
  final String text;

  const RadioItem({this.onChanged, this.value, this.groupValue, this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      onTap: () => press(() => onTap()),
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String title;
  final List<String> values;
  final String selectedValue;
  final ValueChanged onSelect;

  const DropDownItem({this.title = '', this.onSelect, this.values, this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(title ?? ''),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Chip(
              backgroundColor: Colors.grey[200],
              labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              label: DropDownList(
                values: values,
                value: selectedValue,
                onSelect: onSelect,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
