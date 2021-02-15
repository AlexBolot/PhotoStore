/*..............................................................................
 . Copyright (c)
 .
 . The preference_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 13/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_store/services/logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static const String password = 'password';
  static const String email = 'email';
  static const String source = 'photo-source';
  static const String dragAndDropBehaviour = 'drag-drop-behaviour';
}

class DragAndDropBehaviour {
  static const String swap = 'swap';
  static const String reorder = 'reorder';
  static List<String> _values = [swap, reorder];

  static String _current = swap;

  static String get current => _current;

  static Future<void> loadFromPreference() async {
    _current = await getPreference(Preference.dragAndDropBehaviour, orDefault: _current);
  }

  static int indexOf(String source) => _values.indexOf(source);

  static String fromIndex(int index) => _values.elementAt(index);
}

class Source {
  static const String localStorage = 'local';
  static const String firebaseStorage = 'firebase';
  static List<String> _values = [localStorage, firebaseStorage];

  static String _current = firebaseStorage;

  static String get current => _current;

  static Future<void> loadFromPreference() async {
    _current = await getPreference(Preference.source, orDefault: _current);
  }

  static select(String source) {
    _current = source;
    setPreference(Preference.source, _current);
  }

  static int indexOf(String source) => _values.indexOf(source);

  static String fromIndex(int index) => _values.elementAt(index);
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
