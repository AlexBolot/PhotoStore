/*..............................................................................
 . Copyright (c)
 .
 . The secret_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/10/21 2:17 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:convert';

import 'package:flutter/services.dart';

class SecretService {
  static get users async => _getJSON('secrets/accounts.json');

  static get firebaseAccount async => await _getJSON('secrets/firebaseUser.json');

  static _getJSON(String path) async {
    var stringData = await rootBundle.loadString(path);
    return json.decode(stringData);
  }
}
