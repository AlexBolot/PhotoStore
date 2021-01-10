/*..............................................................................
 . Copyright (c)
 .
 . The login_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/10/21 11:05 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_store/config.dart';
import 'package:photo_store/services/account_service.dart';
import 'package:photo_store/services/logging_service.dart';

class LoginView extends StatefulWidget {
  /// Use this for easier access from Named-Routes navigation
  static const String routeName = "/LoginView";

  /// Text displayed as title of this view (in the appbar)
  /// Default is empty string
  final String title;

  const LoginView({this.title = 'LoginView page'});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController(text: 'alex');
  final _pwdController = TextEditingController(text: '@lexandr1');

  @override
  void initState() {
    super.initState();
    _autoLogin().then((result) => logResult('Email-login', result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(child: Text('Photo Store', style: TextStyle(fontSize: 48, color: Colors.white))),
            Container(
              margin: EdgeInsets.all(64),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                elevation: 32.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 4.0),
                            child: Center(child: Icon(Icons.person, size: 32.0)),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: isEmail,
                              controller: _emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                            ),
                          ),
                        ],
                      ),
                      Container(height: 16), // Add space between fields
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 2.0, right: 6.0),
                            child: Center(
                              child: Icon(Icons.lock, size: 28.0),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: validPassword,
                              controller: _pwdController,
                              decoration: InputDecoration(labelText: 'Mot de passe'),
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                      Container(height: 16), // Add space between fields
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: ElevatedButton(
                            child: Text(
                              'Se connecter',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => _login().then((result) => logResult('Auto-login', result)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(height: 100) // Add space under, to avoid keyboard problems
          ],
        ),
      ),
    );
  }

  Future<AttemptResult> _login() async {
    logStep('Attempt email-password login');

    String email = _emailController.text.toLowerCase().trim();
    String password = _pwdController.text.trim();

    if (email.isEmpty || password.isEmpty) return AttemptResult.fail;

    bool isVerified = await AccountService.verifyAccount(email, password);

    if (isVerified) {
      setPreference('email', email);
      setPreference('password', password);

      Navigator.of(context).pushNamed(SplashScreen.routeName);
    }

    return AttemptResult(isVerified);
  }

  Future<AttemptResult> _autoLogin() async {
    logStep('Attempt Auto-login');

    String email = await getPreference('email');
    String password = await getPreference('password');

    if (email == null || password == null) return AttemptResult.fail;

    bool isVerified = await AccountService.verifyAccount(email, password);

    if (isVerified) {
      Navigator.of(context).pushNamed(SplashScreen.routeName);
    }

    return AttemptResult(isVerified);
  }
}
