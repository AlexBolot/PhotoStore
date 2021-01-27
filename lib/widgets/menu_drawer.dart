/*..............................................................................
 . Copyright (c)
 .
 . The menu_drawer.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/27/21 5:08 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_store/config.dart';
import 'package:photo_store/services/firebase/firebase_file_service.dart';
import 'package:photo_store/services/firebase/upload_service.dart';
import 'package:photo_store/services/firebase_service.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/widgets/toggle_switch.dart';

class MenuDrawer extends StatefulWidget {
  final Function(String source) onChangeSource;

  const MenuDrawer({Key key, this.onChangeSource}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool status = false;

  @override
  void initState() {
    super.initState();

    getPreference(Preference.source).then((value) {
      setState(() => status = Source.asBoolean(value));
    });
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
          SimpleItem(
            icon: Icons.upload_sharp,
            text: 'Upload with labels',
            onPress: () => UploadService.uploadWithLabels(),
          ),
          SimpleItem(
            icon: Icons.list_alt_rounded,
            text: 'Charger liste firestore',
            onPress: () => FirebaseService.fetchFirestoreContent(),
          ),
          ToggleItem(
            text: 'Changer de source',
            activeText: 'Firebase',
            inactiveText: 'Local',
            status: status,
            onChange: (value) {
              setState(() => status = value);
              widget.onChangeSource(Source.fromBoolean(value));
            },
          ),
          SimpleItem(
            icon: Icons.delete,
            text: 'Libérer de l\'espace',
            onPress: () => FirebaseFileService.freeSpaceOnDevice(),
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

  const SimpleItem({Key key, this.icon, this.text, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon),
      title: Text(text),
      onTap: () => press(onPress),
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
