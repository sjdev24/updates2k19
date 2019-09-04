import 'dart:math';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:updates_2k19/blocs/my_event_bloc.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/screens/actions_on_qr_screen.dart';
import 'package:updates_2k19/settings/colors.dart';

class MyEventScreen extends StatefulWidget {
  @override
  _MyEventScreenState createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen> {
  String code;
  String query;
  MyEventBloc _bloc;

  void _scanQR() async {
    try {
      code = await BarcodeScanner.scan();
    } on Exception {}

//
//    code =
//        'ZuK9l/1axbkitz4TaXlRGRDjepHRHAYAaA77S1v3iSDmX3qVObks6AksLCaGhYHne03vvc3hQM2+GXeL+qDbOg==';
//    // Paid event code
//    code =
//        'ZuK9l/1bwrsqvDoVbnlRIxzbe4L5QjEkVAL3Y1nshTXOQGC7e+FT5jIsLFjVvpj0XXvHuprwf4yjU2KPppCAOg==';
//

    if (code != null && code.isNotEmpty) {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => ActionsOnQRScreen(
                qrString: code,
              )));
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = MyEventBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: kColorPrimaryDark,
          shape: _DiamondNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 48,
              )
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () => _scanQR(),
          child: Material(
            shape: _DiamondBorder(),
            color: kColorSecondaryLight,
            child: Container(
              width: 72,
              height: 72,
              child: IconTheme.merge(
                data: Theme.of(context)
                    .accentIconTheme
                    .copyWith(color: kColorTextSecondaryLight),
                child: Icon(Icons.camera_alt),
              ),
            ),
            elevation: 7.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText: 'Email, Mobile Number, Enrolment',
                  labelText: 'Search'),
              onChanged: _bloc.query.add,
            ),
            SizedBox(
              height: 4,
            ),
            StreamBuilder<String>(
                stream: _bloc.preamble,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? '',
                  );
                }),
            Text(
              'Search will be available in next version.',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
//            StreamBuilder<List<User>>(
//              stream: _bloc.result,
//              builder: (context, snapshot) {
//                if (!snapshot.hasData || snapshot.data.length == 0)
//                  return Text('No Data');
////                return ListView.separated(
////                  shrinkWrap: true,
////                  itemCount: snapshot.data.length,
////                  separatorBuilder: (BuildContext context, int index) {
////                    return SizedBox();
////                  },
////                  itemBuilder: (BuildContext context, int index) {
////                    return Text('$index ${snapshot.data[index].email}');
////                  },
////                );
//                List<UserExpansionItem> userItems =
//                snapshot.data.map<UserExpansionItem>((u) {
//                  return UserExpansionItem(
//                      header: '${u.first_name} ${u.last_name}',
//                      isExpanded: true,
//                      user: u);
//                }).toList();
//                return ListView(
//                  shrinkWrap: true,
//                  children: <Widget>[
//                    ExpansionPanelList(
//                      expansionCallback: (int index, bool isExpanded) {
//                        setState(() {
//                          userItems[index].expansionToggle();
//                        });
//                      },
//                      children: userItems.map<ExpansionPanel>((item) {
//                        return ExpansionPanel(
//                          headerBuilder:
//                              (BuildContext context, bool isExpanded) {
//                            return ListTile(
//                              title: Text(item.user.email),
//                            );
//                          },
//                          body: item.body,
//                          isExpanded: item.isExpanded,
//                        );
//                      }).toList(),
//                    ),
//                  ],
//                );
//              },
//            ),
          ],
        ));
  }
}

class UserExpansionItem {
  bool isExpanded;
  final String header;
  Widget body;
  final User user;

  void expansionToggle() {
    print(isExpanded);
    isExpanded = !isExpanded;
  }

  UserExpansionItem({this.header, this.isExpanded, this.user}) {
    body = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '${user.first_name} ${user.last_name}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 56,
            ),
          ],
        ),
      ),
    );
  }
}

// source: https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/bottom_app_bar_demo.dart
class _DiamondNotchedRectangle implements NotchedShape {
  const _DiamondNotchedRectangle();

  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (!host.overlaps(guest)) return Path()..addRect(host);
    assert(guest.width > 0.0);

    final Rect intersection = guest.intersect(host);

    final double notchToCenter =
        intersection.height * (guest.height / 2.0) / (guest.width / 2.0);

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(guest.center.dx - notchToCenter, host.top)
      ..lineTo(guest.left + guest.width / 2.0, guest.bottom)
      ..lineTo(guest.center.dx + notchToCenter, host.top)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}

class _DiamondBorder extends ShapeBorder {
  const _DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}
