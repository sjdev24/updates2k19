import 'package:flutter/material.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/settings/constants.dart';

class NavigationMenuScreen extends StatelessWidget {
  final NavigationMenuItem currentMenuItem;
  final ValueChanged<NavigationMenuItem> onMenuItemTap;
  final List<NavigationMenuItem> menuItems;

  const NavigationMenuScreen(
      {Key key,
      @required this.currentMenuItem,
      @required this.onMenuItemTap,
      @required this.menuItems})
      : assert(currentMenuItem != null),
        assert(onMenuItemTap != null),
        assert(menuItems != null);

  Widget _buildCategory(NavigationMenuItem menuItem, BuildContext context) {
    final menuItemString = menuItem
        .toString()
        .replaceAll('NavigationMenuItem.', '')
        .replaceAll('_', ' ')
        .toUpperCase();
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onMenuItemTap(menuItem),
      child: menuItem == currentMenuItem
          ? Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text(
                  menuItemString,
                  style: theme.textTheme.body2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14.0),
                Container(
                  width: 70.0,
                  height: 3.0,
                  color: kColorSurfaceDark,
                ),
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                menuItemString,
                style: theme.textTheme.body2
                    .copyWith(color: kColorTextPrimary.withAlpha(153)),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: kColorPrimaryDark,
        padding: EdgeInsets.only(top: 40.0),
        child: ListView(
            children: menuItems
                .map((NavigationMenuItem c) => _buildCategory(c, context))
                .toList()),
      ),
    );
  }
}
