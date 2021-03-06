/*..............................................................................
 . Copyright (c)
 .
 . The menu_drawer.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/03/2021
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

  refreshAndParent() {
    widget.updateParent();
    setState(() {});
  }

  changeSource(String value) {
    Source.current = value;
    refreshAndParent();
  }

  changeDragDropBehaviour(String value) {
    DragAndDropBehaviour.current = value;
    refreshAndParent();
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
          ToggleItem<String>(
            isActive: Source.current == Source.firebaseStorage,
            title: 'Source des photos',
            activeText: 'Firebase',
            activeValue: Source.firebaseStorage,
            inactiveText: 'Local',
            inactiveValue: Source.localStorage,
            onChange: (value) => changeSource(value),
          ),
          ToggleItem<String>(
            isActive: DragAndDropBehaviour.current == DragAndDropBehaviour.reorder,
            title: 'Drag and Drop',
            activeText: 'Réordonner',
            activeValue: DragAndDropBehaviour.reorder,
            inactiveText: 'Échanger',
            inactiveValue: DragAndDropBehaviour.swap,
            onChange: (value) => changeDragDropBehaviour(value),
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

class ToggleItem<T> extends StatelessWidget {
  final String title;
  final String activeText;
  final String inactiveText;
  final T activeValue;
  final T inactiveValue;
  final bool isActive;
  final ValueChanged<T> onChange;

  const ToggleItem({
    @required this.title,
    this.activeText,
    this.inactiveText,
    this.isActive = false,
    this.onChange,
    this.activeValue,
    this.inactiveValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(child: Text(title, style: TextStyle(fontSize: 18))),
          Flexible(
            child: ToggleSwitch(
              activeItem: ToggleSwitchItem(
                text: activeText,
                color: Theme.of(context).primaryColor,
                value: activeValue,
              ),
              inactiveItem: ToggleSwitchItem(
                text: inactiveText,
                value: inactiveValue,
              ),
              isActive: isActive,
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
