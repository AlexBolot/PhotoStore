/*..............................................................................
 . Copyright (c)
 .  
 . The firebase_file.dart class was created by : Alex Bolot and Pierre Bolot
 .  
 . As part of the PhotoStore project
 .  
 . Last modified : 1/28/21 3:06 PM
 .  
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/firebase/firebase_file_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseFile {
  Reference reference;
  String name;
  AssetType type;

  File _file;

  FirebaseFile(Reference ref) {
    this.reference = ref;
    this.name = ref.name;
    this.type = _findType();
  }

  Future<File> get file async {
    var fileAvailable = (_file != null && _file.existsSync());
    return fileAvailable ? _file : _file ??= await _loadFile();
  }

  SavePath get savePath => SavePath(reference.parent.name, name);

  // ------------------ Private methods ------------------ //

  Future<File> _loadFile() async {
    var downloadUrl = await reference.getDownloadURL();
    return await FirebaseFileService.getFile(downloadUrl, savePath);
  }

  AssetType _findType() {
    var fileExtension = reference.name.split('.').last.toLowerCase();

    switch (fileExtension) {
      case 'jpg':
      case 'png':
      case 'jpeg':
        return AssetType.image;
      case 'mp4':
      case 'webm':
        return AssetType.video;
      default:
        logWarning('Unknown file type $fileExtension');
        return AssetType.other;
    }
  }
}
