/*..............................................................................
 . Copyright (c)
 .
 . The menu_drawer.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/20/21 1:01 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/services/classification_service.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/services/preference_service.dart';
import 'package:photo_store/widgets/toggle_switch.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool status = false;

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
          ListTile(
            leading: Icon(Icons.upload_sharp),
            title: Text('Upload with labels'),
            onTap: uploadWithLabels,
          ),
          Container(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Changer de source', style: TextStyle(fontSize: 18)),
              Container(
                child: ToggleSwitch(
                  activeText: 'Firebase',
                  inactiveText: 'Local',
                  activeColor: Theme.of(context).primaryColor,
                  isActive: status,
                  onChanged: (value) {
                    logStep('Switched source to ${value ? 'Firebase' : 'Local'}');
                    setPreference(Preferences.source, '');
                    setState(() => status = value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

uploadWithLabels() async {
  Directory appDocumentsDirectory = await getExternalStorageDirectory();
  var directories = appDocumentsDirectory.listSync();

  var entity = directories.first;
  if (entity is Directory) {
    Directory dir = entity;

    int count = 0;

    dir.listSync().forEach((item) {
      logDebug(item.path);

      if (count > 10) return;

      if (item is File) {
        var fileExtension = item.path.split('.').last.toLowerCase();

        bool isImage = ['jpg', 'png', 'jpeg'].contains(fileExtension);

        if (isImage) {
          ClassificationService.labelFile(item);
          count++;
        }
      }
    });
  }
}
