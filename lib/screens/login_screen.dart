import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:updates_2k19/screens/components/frosted_screen.dart';
import 'package:updates_2k19/screens/home_screen.dart';
import 'package:updates_2k19/screens/user_registration_screen.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/utilities/asset_helper.dart';
import 'package:updates_2k19/utilities/auth_helper.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';
import 'package:updates_2k19/utilities/operation_handling.dart';

class LoginScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/LoginScreen';

  final StatusCode statusCode;

  LoginScreen({this.statusCode});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthHelper _authHelper = AuthHelper.instance;

  Future<bool> _processingStream = Future<bool>.value(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: ConnectivityHelper.internetConnectivity,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Hero(
                      tag: 'main_logo',
                      child: Image.asset(
                        AssetHelper.UPDATES_LOGO,
                        height: 200.0,
                      ),
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    SizedBox(
                      height: 40.0,
                      child: RaisedButton(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero)),
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        color: kColorTextPrimaryDark,
                        onPressed: () {
                          handleLogin(context);
                        },
                        textTheme: Theme.of(context).buttonTheme.textTheme,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/logo/google.png',
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: 24.0,
                            ),
                            Text(
                              'Sign in with Google'.toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: kColorTextPrimaryLight,
                                      ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<bool>(
                stream: _processingStream.asStream(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot == null || snapshot.data == false) {
                    return SizedBox();
                  } else {
                    return FrostedScreen(
                      color: Colors.grey[700].withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: null,
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }

  void handleLogin(BuildContext context) async {
    await ConnectivityHelper.checkConnection(context: context);
    String newRouteName;
    if (ConnectivityHelper.internetConnectivity.value ?? false) {
      // TODO: Fix CircularProgressBar
      var x = _authHelper.handleSignIn();
      newRouteName = await x;
//      _processingStream = Future<bool>.value(false);
    } else
      return;
    if (newRouteName == HomeScreen.ROUTE_NAME) {
      if (Navigator.of(context).canPop())
        Navigator.of(context).pop();
      else
        Navigator.of(context).pushReplacementNamed('/');
    } else if (newRouteName == LoginScreen.ROUTE_NAME)
      return;
    else
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => UserRegistrationScreen(),
        fullscreenDialog: true,
      ));
  }
}
