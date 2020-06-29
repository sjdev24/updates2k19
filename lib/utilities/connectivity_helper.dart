import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:updates_2k19/screens/no_internet_screen.dart';

class ConnectivityHelper {
  static var _internetConnectivitySubject = BehaviorSubject<bool>();

  static ValueObservable<bool> get internetConnectivity =>
      _internetConnectivitySubject.stream;

  static Route<Object> get _getNoInternetScreenRoute => PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) =>
          NoInternetScreen(),
      opaque: false);

  static Future<bool> checkConnection({BuildContext context}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _internetConnectivitySubject.sink.add(true);
      } else {
        _internetConnectivitySubject.sink.add(false);
      }
    } on SocketException catch (_) {
      _internetConnectivitySubject.sink.add(false);
    }
    if (context == null) return internetConnectivity.value;

    if (internetConnectivity.value == false) {
      if (context == null) {
        return internetConnectivity.value;
      }
      Navigator.of(context).push(
        _getNoInternetScreenRoute,
      );
    }
    return internetConnectivity.value;
  }
}
