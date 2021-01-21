/*..............................................................................
 . Copyright (c)
 .
 . The preference_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/21/21 10:18 AM
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
}

SharedPreferences pref;

setPreference(String key, String value) async {
  pref ??= await SharedPreferences.getInstance();

  logDebug('Setting Preference -> $key :: $value');

  pref.setString(key, value);
}

Future<String> getPreference(String key, {String orDefault}) async {
  pref ??= await SharedPreferences.getInstance();

  var hasValue = pref.containsKey(key);

  if (hasValue) {
    var value = pref.getString(key);
    logDebug('Fetching Preference -> $key :: $value');
    return value;
  } else {
    logDebug('Fetching Preference -> $key not found !');
    return orDefault;
  }
}