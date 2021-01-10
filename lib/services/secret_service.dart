/*..............................................................................
 . Copyright (c)
 .
 . The secret_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/10/21 5:26 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:photo_store/model/account.dart';

class SecretService {
  static Future<List<Account>> get accounts async {
    var jsonUsers = await _fetchData('secrets/accounts.json');
    return jsonUsers.map((jsonUser) => Account.fromJSON(jsonUser));
  }

  static Future<Account> get firebaseAccount async {
    var jsonUser = await _fetchData('secrets/firebaseUser.json');
    return Account.fromJSON(jsonUser);
  }

  static _fetchData(String path) async {
    var stringData = await rootBundle.loadString(path);
    return json.decode(stringData);
  }
}
