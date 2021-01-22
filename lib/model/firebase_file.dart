/*..............................................................................
 . Copyright (c)
 .  
 . The firebase_file.dart class was created by : Alex Bolot and Pierre Bolot
 .  
 . As part of the PhotoStore project
 .  
 . Last modified : 1/22/21 1:52 AM
 .  
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/firebase/download_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseFile {
  Reference reference;
  String downloadUrl;
  String name;
  AssetType type;

  File _file;

  FirebaseFile(Reference ref) {
    this.reference = ref;
    this.name = ref.name;
    this.type = _findType();
  }

  Future<File> get file async {
    _file ??= await _loadFile();
    return _file;
  }

  Future<File> _loadFile() async {
    var parentDir = reference.parent.name;
    var savePath = SavePath(parentDir, name);

    return DownloadService.downloadFile(downloadUrl, savePath);
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
        logDebug('WARNING : Unknown file type $fileExtension');
        return AssetType.other;
    }
  }
}
