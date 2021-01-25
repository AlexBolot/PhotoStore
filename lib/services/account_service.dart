/*..............................................................................
 . Copyright (c)
 .
 . The account_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 10:42 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_store/model/account.dart';
import 'package:photo_store/services/logging_service.dart';
import 'package:photo_store/services/secret_service.dart';

class AccountService {
  static final _auth = FirebaseAuth.instance;
  static Account currentAccount;

  static Future<AttemptResult> loginToFirebase() async {
    var user = await SecretService.firebaseAccount;

    try {
      await _auth.signInWithEmailAndPassword(email: user.email, password: user.password);
      return AttemptResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          logWarning('No user found with email ${user.email}');
          break;
        case 'wrong-password':
          logWarning("Wrong password provided for ${user.email}");
          break;
      }

      return AttemptResult.fail;
    }
  }

  static Future<bool> verifyAccount(String email, String password) async {
    List<Account> accounts = await SecretService.accounts;

    for (Account account in accounts) {
      if (account.matches(email, password)) {
        currentAccount = account;
        return true;
      }
    }

    return false;
  }
}
