/*..............................................................................
 . Copyright (c)
 .
 . The menu_drawer.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_store/global.dart';
import 'package:photo_store/services/firebase/upload_service.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/widgets/toggle_switch.dart';

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

  changeSource(String value) {
    Source.select(value);
    widget.updateParent();
    setState(() {});
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
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Title(child: Text('Photo Source'), color: Colors.yellow),
          RadioItem(
            text: 'Firebase',
            value: Source.firebaseStorage,
            groupValue: Source.currentSource,
            onChanged: (value) => changeSource(value),
            onTap: () => changeSource(Source.firebaseStorage),
          ),
          RadioItem(
            text: 'Local',
            value: Source.localStorage,
            groupValue: Source.currentSource,
            onChanged: (value) => changeSource(value),
            onTap: () => changeSource(Source.localStorage),
          ),
          SimpleItem(
            icon: Icons.upload_sharp,
            text: 'Upload with labels',
            onPress: () => UploadService.uploadWithLabels(),
          ),
          /*SimpleItem(
            icon: Icons.delete,
            text: 'Libérer de l\'espace',
            onPress: () {
              CacheService.freeSpaceOnDevice(Duration());
              widget.onChange();
            },
          ),*/
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

class ToggleItem extends StatelessWidget {
  final String text;
  final String activeText;
  final String inactiveText;
  final bool status;
  final Function(bool) onChange;

  const ToggleItem({this.text, this.activeText, this.inactiveText, this.status, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(text, style: TextStyle(fontSize: 18)),
          Container(
            child: ToggleSwitch(
              activeText: activeText,
              inactiveText: inactiveText,
              activeColor: Theme.of(context).primaryColor,
              isActive: status,
              onChanged: (value) => press(() => onChange(value)),
            ),
          ),
        ],
      ),
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
