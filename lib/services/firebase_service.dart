/*..............................................................................
 . Copyright (c)
 .
 . The firebase_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 11:00 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_store/services/logging_service.dart';

class FirebaseService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final HttpClient httpClient = HttpClient();

  static Map<String, File> loadedImages = {};
  static Map<String, File> loadedThumbnails = {};

  static void fetchFirestoreContent() async {
    ListResult listResults = await _storage.ref('Alex').listAll();
    listResults.prefixes.forEach((element) async {
      logDebug(element.name);
      logDebug((await element.listAll()).items.map((e) => e.name).join('\n'));
    });
  }

  // ---------- Private methods ------------- //

  static Future downloadThumbnail(String url, String name) async {
    loadedThumbnails[url] = await _downloadFile(url, '${name}_thumbnail');
    logDebug('>> Downloaded Thumbnail : $name');
  }

  static Future downloadImage(String url, String name) async {
    loadedImages[url] = await _downloadFile(url, '${name}_image');
    logDebug('>> Downloaded Image : $name');
  }

  static Future<File> _downloadFile(String url, String filename) async {
    if (url != null) {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);

      String dir = (await getTemporaryDirectory()).path;

      return await File('$dir/$filename').writeAsBytes(bytes);
    }

    return null;
  }

  /*static Future<File> _generateThumbnail(File file, String fileName) async {
    int startTime = getTime();

    img.Image temp = img.decodeImage(file.readAsBytesSync());
    img.Image thumbnail = img.copyResize(temp, width: 400, height: 400);

    logDelay('Resized thumbnail', startTime, getTime());

    startTime = getTime();

    Directory directory = await getApplicationDocumentsDirectory();

    File file2 = File(directory.path + Platform.pathSeparator + fileName)
      ..createSync()
      ..writeAsBytesSync(img.encodeJpg(thumbnail, quality: 70));

    logDelay('Created thumbnail file', startTime, getTime());

    return file2;
  }*/
}
