import 'dart:ui' as dartUI;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FrostedScreen extends StatelessWidget {
  final Widget child;
  final Color color;

  static final Color _kColorFrostedScreenBlur =
      Colors.grey[700].withOpacity(0.5);

  const FrostedScreen({Key key, this.color, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    return WillPopScope(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            BackdropFilter(
              filter: dartUI.ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                constraints: BoxConstraints.expand(),
                color: color ?? _kColorFrostedScreenBlur,
              ),
            ),
            child,
          ],
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
