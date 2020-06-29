import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:updates_2k19/screens/components/cut_corners_border.dart';
import 'package:updates_2k19/settings/colors.dart';

enum NavigationMenuItem {
  home,
  all_Events,
  participated,
  sponsors,
  developer_Team,
  my_Event,
  updates2k19,
  updates2k19_Team,
}

const List<NavigationMenuItem> kStudentNavigationMenuItems =
    <NavigationMenuItem>[
  NavigationMenuItem.home,
  NavigationMenuItem.all_Events,
  NavigationMenuItem.participated,
  NavigationMenuItem.sponsors,
  NavigationMenuItem.developer_Team,
  NavigationMenuItem.updates2k19_Team
];

const List<NavigationMenuItem> kCoordinatorNavigationMenuItems =
    <NavigationMenuItem>[
  NavigationMenuItem.home,
  NavigationMenuItem.my_Event,
  NavigationMenuItem.all_Events,
  NavigationMenuItem.participated,
  NavigationMenuItem.sponsors,
  NavigationMenuItem.developer_Team,
  NavigationMenuItem.updates2k19_Team
];

const List<NavigationMenuItem> kHeadNavigationMenuItems = <NavigationMenuItem>[
  NavigationMenuItem.home,
  NavigationMenuItem.updates2k19,
  NavigationMenuItem.my_Event,
  NavigationMenuItem.all_Events,
  NavigationMenuItem.sponsors,
  NavigationMenuItem.developer_Team,
  NavigationMenuItem.updates2k19_Team
];

const String kEventName = 'Updates 2K19';

final RegExp kRegExpEmail = RegExp(
    "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");
final RegExp kRegExpEnrolment = RegExp("^[0-9]{12}\$");
final RegExp kRegExpPhone = RegExp("^([+][0-9]{1,3})?([0-9]{10})\$");
final RegExp kRegExpOldQR = RegExp("^([0-9]+)\.(.+)\.(.+)\$");

TextStyle kTextStyleTitleHindi(TextStyle base) {
  return base.copyWith(
    fontFamily: 'Noto Sans',
    fontWeight: FontWeight.w700,
  );
}

kCutsomTextInputDecoration(label) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: kColorPrimaryLight),
    border:
        OutlineInputBorder(borderSide: BorderSide(color: kColorPrimaryLight)),
    enabledBorder: CutCornersBorder(
      borderSide: BorderSide(color: kColorPrimaryLight),
    ),
    focusedErrorBorder: CutCornersBorder(
        borderSide: BorderSide(
      color: kColorPrimaryDark,
    )),
    errorBorder:
        CutCornersBorder(borderSide: BorderSide(color: kColorSecondaryLight)),
    errorStyle: TextStyle(color: kColorSecondaryLight));

final kVersionName = PackageInfo.fromPlatform().then<String>((value) {
  return 'v${value.version}';
});
