import 'package:flutter/material.dart';
import 'package:updates_2k19/settings/colors.dart';

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
        textSelectionColor: Colors.white,
        cursorColor: kColorPrimaryLight,
      ),
    );
  }
}
