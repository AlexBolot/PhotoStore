/*..............................................................................
 . Copyright (c)
 .
 . The account_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/10/21 11:05 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/services/secret_service.dart';

class AccountService {
  static final _auth = FirebaseAuth.instance;

  static Future<AttemptResult> loginToFirebase() async {
    var firebaseUser = await SecretService.firebaseAccount;

    var email = firebaseUser['email'];
    var password = firebaseUser['password'];

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return AttemptResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          logDebug('No user found with email $email');
          break;
        case 'wrong-password':
          logDebug("Wrong password provided for $email");
          break;
      }

      return AttemptResult.fail;
    }
  }

  static Future<bool> verifyAccount(String email, String password) async {
    List users = await SecretService.users;
    return users.any((user) => user['email'] == email && user['password'] == password);
  }
}
