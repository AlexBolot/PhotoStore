/*..............................................................................
 . Copyright (c)
 .
 . The preference_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_store/services/logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static const String password = 'password';
  static const String email = 'email';
  static const String source = 'photo-source';
}

class Source {
  static const String localStorage = 'local';
  static const String firebaseStorage = 'firebase';

  static String _currentSource;

  static String get currentSource => _currentSource;

  static Future init() async {
    _currentSource = await getPreference(Preference.source, orDefault: Source.firebaseStorage);
  }

  static select(String source) {
    _currentSource = source;
    setPreference(Preference.source, _currentSource);
  }

  static int indexOf(String source) {
    switch (source) {
      case localStorage:
        return 0;
      case firebaseStorage:
        return 1;
      default:
        throw 'No Source matches $source';
    }
  }

  static String fromIndex(int index) {
    switch (index) {
      case 0:
        return localStorage;
      case 1:
        return firebaseStorage;
      default:
        throw 'No Source matches index $index';
    }
  }
}

/// Global photo source shared through the App (Local or Firebase)
String currentSource;
SharedPreferences pref;

Future setPreference(String key, String value) async {
  pref ??= await SharedPreferences.getInstance();

  logInfo('Setting Preference -> $key :: $value');

  pref.setString(key, value);
}

Future<String> getPreference(String key, {String orDefault}) async {
  pref ??= await SharedPreferences.getInstance();

  var hasValue = pref.containsKey(key);

  if (hasValue) {
    var value = pref.getString(key);
    logInfo('Fetching Preference -> $key :: $value');
    return value;
  } else {
    logInfo('Fetching Preference -> $key not found !');
    return orDefault;
  }
}
