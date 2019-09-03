import 'package:flutter/material.dart';
import 'package:updates_2k19/settings/colors.dart';

class TransparentParent extends StatelessWidget {
  final Widget child;

  TransparentParent({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorTransparentScreen,
      body: SafeArea(
        child: child,
      ),
    );
  }
}
