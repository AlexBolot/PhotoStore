/*..............................................................................
 . Copyright (c)
 .
 . The preference_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/28/21 11:01 AM
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
  static const String firebaseStorage = 'firebase';
  static const String localStorage = 'local';

  static const List<String> values = [localStorage, firebaseStorage];

  static int indexOf(String source) => values.indexOf(source);

  static String fromIndex(int index) => values[index];
}

SharedPreferences pref;

setPreference(String key, String value) async {
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
