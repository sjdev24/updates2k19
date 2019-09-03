import 'package:flutter/material.dart';
import 'package:updates_2k19/screens/all_events_screen.dart';
import 'package:updates_2k19/utilities/asset_helper.dart';
import 'package:updates_2k19/utilities/auth_helper.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetHelper.UPDATES_POSTER,
      fit: BoxFit.fitHeight,
    );
//    return ListView(children: <Widget>[
//      FlatButton(
//        onPressed: () {
//          Navigator.of(context).push(
//            MaterialPageRoute(builder: (context) => AllEventsScreen()),
//          );
//        },
//        child: Text(
//          'Events',
//        ),
//      ),
//      SizedBox(
//        height: 24.0,
//      ),
//      FlatButton(
//        child: Text('Logout'),
//        onPressed: () {
//          AuthHelper.instance.logMeOut(context);
//        },
//      )
//    ]);
  }
}
