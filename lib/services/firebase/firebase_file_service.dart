/*..............................................................................
 . Copyright (c)
 .
 . The firebase_file_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 5:38 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:photo_store/model/save_path.dart';
import 'package:photo_store/services/firebase/download_service.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseFileService {
  static String _localAppDirectory;

  static Future<File> getFile(String downloadUrl, SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;

    var localFile = File(_localAppDirectory + '/' + savePath.formatted);

    if (localFile.existsSync()) {
      return localFile;
    } else {
      logDebug('Must download ${savePath.formatted}');
      return await DownloadService.downloadFile(downloadUrl, savePath);
    }
  }

  static Future<File> saveFile(List<int> bytes, SavePath savePath) async {
    _localAppDirectory ??= (await getApplicationDocumentsDirectory()).path;
    var directory = Directory(_localAppDirectory + '/' + savePath.directory);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    var file = File(directory.path + '/' + savePath.fileName);

    file.writeAsBytesSync(bytes);

    return file;
  }
}
