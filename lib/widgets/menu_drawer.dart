/*..............................................................................
 . Copyright (c)
 .
 . The menu_drawer.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/22/21 11:07 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/config.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/classification_service.dart';
import 'package:photo_store/services/firebase/upload_service.dart';
import 'package:photo_store/services/firebase_service.dart';
import 'package:photo_store/services/logging_service.dart';
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
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Icon(Icons.upload_sharp),
            title: Text('Upload with labels'),
            onTap: () => press(uploadWithLabels),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Icon(Icons.list_alt_rounded),
            title: Text('Charger liste firestore'),
            onTap: () => press(() => FirebaseService.fetchFirestoreContent()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
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
                      press(() {
                        setState(() => status = value);
                        widget.onChangeSource(Source.fromBoolean(value));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          /*Image(
            image: FirebaseImage(
              'gs://photostore-firebase.appspot.com/Alex/10814250_741285582632220_1788011061_n_741285582632220.jpg',
              shouldCache: true, // The image should be cached (default: True)
              maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
              cacheRefreshStrategy: CacheRefreshStrategy.NEVER, // Switch off update checking
            ),
            width: 100,
          ),*/
        ],
      ),
    );
  }
}

uploadWithLabels() async {
  Directory appDocumentsDirectory = await getExternalStorageDirectory();
  var directories = appDocumentsDirectory.listSync();

  directories.take(5).forEach((dir) async {
    if (dir is Directory) {
      int count = 0;

      logDebug('------ ${dir.path.split('/').last} ------');
      var dirName = dir.path.split('/').last;

      for (var item in dir.listSync()) {
        if (count > 10) return;

        if (item is File) {
          var fileExtension = item.path.split('.').last.toLowerCase();
          bool isImage = ['jpg', 'png', 'jpeg'].contains(fileExtension);

          if (isImage) {
            logDebug('-- ${item.path.split('/').last}');
            var imageName = item.path.split('/').last;

            var labels = await ClassificationService.labelFile(item);
            UploadService.saveFile(item, SavePath(dirName, imageName), labels);
            count++;
          }
        }
      }
    }
  });
}
