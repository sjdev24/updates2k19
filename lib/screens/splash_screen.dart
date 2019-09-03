import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:updates_2k19/screens/login_screen.dart';
import 'package:updates_2k19/screens/user_registration_screen.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/settings/constants.dart';
import 'package:updates_2k19/utilities/asset_helper.dart';
import 'package:updates_2k19/utilities/auth_helper.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';
import 'package:updates_2k19/utilities/operation_handling.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AuthHelper _authHelper = AuthHelper.instance;
  String destination;
  Future<bool> goodToGoAhead;

  Animation<double> _animation;
  AnimationController _controller;

  var _moveToNewPage;

  void workOnAuthentication() async {
    goodToGoAhead = Future<bool>.value(false);
    Future<StatusCode> status = _authHelper.getAuthenticationStatus();
    status.then((value) {
      print(value);
      if (value == StatusCode.AUTH_NOT_LOGGED_IN) {
//        Navigator.of(context).pushNamed(LoginScreen.ROUTE_NAME);
        _moveToNewPage = LoginScreen.ROUTE_NAME;
      } else if (value == StatusCode.AUTH_NOT_REGISTERED) {
//        Navigator.of(context).pushNamed(UserRegistrationScreen.ROUTE_NAME);
        _moveToNewPage = UserRegistrationScreen.ROUTE_NAME;
      }
      print(_moveToNewPage);
      goodToGoAhead = Future<bool>.value(true);
    });

//    var isLoggedIn = await _authHelper.isLoggedIn();
//    if (isLoggedIn) {
//      print('logged in');
//      if (await _authHelper.isUserExist())
//        destination = HomeScreen.ROUTE_NAME;
//      else
//        destination = UserRegistrationScreen.ROUTE_NAME;
//      goodToGoAhead = Future<bool>.value(true);
//    } else {
//      print('sign in please');
//      destination = LoginScreen.ROUTE_NAME;
//      goodToGoAhead = Future<bool>.value(true);
//    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 360).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        ConnectivityHelper.checkConnection(context: context);
        await workOnAuthentication();
        Navigator.of(context).pushReplacementNamed(_moveToNewPage);
//        goodToGoAhead.then((value) {
//          if (value == true) {
//          }
//        });
      }
    });

    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Transform.rotate(
                child: Hero(
                  tag: 'main_logo',
                  child: Image.asset(
                    AssetHelper.UPDATES_LOGO,
                    height: 300.0,
                  ),
                ),
                angle: (math.pi * _animation.value) / 180.0,
              ),
              SizedBox(
                height: 100.0,
              ),
              Text(
                kEventName.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .display4
                    .copyWith(fontSize: 48, color: kColorTextPrimaryDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
