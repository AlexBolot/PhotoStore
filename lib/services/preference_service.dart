/*..............................................................................
 . Copyright (c)
 .
 . The preference_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/20/21 6:10 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:photo_store/services/logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String passwordKey = 'password';
const String emailKey = 'email';
const String sourceKey = 'photo-source';

class Preferences {
  static String password = 'password';
  static String email = 'email';
  static String source = 'photo-source';
}

SharedPreferences pref;

setPreference(String key, String value) async {
  pref ??= await SharedPreferences.getInstance();

  logger.fine('Setting Preference -> $key :: $value');

  pref.setString(key, value);
}

Future<String> getPreference(String key) async {
  pref ??= await SharedPreferences.getInstance();
  var value = pref.getString(key);

  logger.fine('Fetching Preference -> $key :: $value');

  return value;
}
