/*..............................................................................
 . Copyright (c)
 .  
 . The firebase_file.dart class was created by : Alex Bolot and Pierre Bolot
 .  
 . As part of the PhotoStore project
 .  
 . Last modified : 2/5/21 5:34 PM
 .  
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/extensions.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/firebase/firebase_file_service.dart';
import 'package:photo_store/services/firebase/firebase_label_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseFile {
  Reference reference;
  String name;
  AssetType type;
  List<String> _labels;

  FirebaseFile(Reference ref) {
    this.reference = ref;
    this.name = ref.name;
    this.type = _findType();
  }

  // ------------------ Methods and getters ------------------ //

  Future<File> get file async => await FirebaseFileService.getFile(reference, savePath);

  Future<List<String>> get labels async => _labels ??= await FirebaseFileService.getLabels(savePath);

  SavePath get savePath => SavePath(reference.parent.name, name);

  void addLabel(String label) {
    FirebaseLabelService.saveFileLabels(savePath, _labels..addNew(label));
    FirebaseLabelService.addGlobalLabel(label);
  }

  void removeLabel(String label) {
    FirebaseLabelService.saveFileLabels(savePath, _labels..remove(label));
    FirebaseLabelService.deleteGlobalLabel(label);
  }

  // ------------------ Private methods ------------------ //

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
