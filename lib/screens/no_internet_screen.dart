import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';

class NoInternetScreen extends StatelessWidget {
  static final String ROUTE_NAME = "NoInternetScreen";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                color: Colors.grey[200].withOpacity(0.5),
                constraints: BoxConstraints.expand(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Not connected to internet'.toUpperCase(),
                    style: Theme.of(context).textTheme.display3.copyWith(
                        fontSize: 24.0,
                        color: kColorTextPrimaryLight.withOpacity(0.5)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  SizedBox(
                    height: 48.0,
                    child: RaisedButton(
                      elevation: 4.0,
                      onPressed: () async {
                        await ConnectivityHelper.checkConnection();
                        bool connected =
                            ConnectivityHelper.internetConnectivity.value;
                        if (connected == true) Navigator.of(context).pop();
                      },
                      child: Text(
                        'RETRY',
                      ),
                      textTheme: Theme.of(context).buttonTheme.textTheme,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
