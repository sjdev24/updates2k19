import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:updates_2k19/blocs/event_screen_bloc.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/screens/components/loading_screen.dart';
import 'package:updates_2k19/screens/participate_screen.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/utilities/asset_helper.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';

class EventScreen extends StatelessWidget {
  static const String ROUTE_NAME = '/EventScreen';
  final Event event;
  GlobalKey<NavigatorState> _navigatorKey;

  EventScreen(this.event);

  EventScreenBloc _bloc;

  final _dateFormat = DateFormat("d MMMM");
  final _timeFormat = DateFormat("hh:mm a");

  bool _descriptionExpanded = false;
  bool _teamEvent;
  String _eventType;

  void participate(BuildContext context) async {
    await ConnectivityHelper.checkConnection(context: context);
    // DONE: Fix this
    _navigatorKey.currentState.push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingScreen(),
      ),
    );
    bool isRegistered = await _bloc.isUserRegistered(event);
    _navigatorKey.currentState.pop();
    if (isRegistered) {
      // DONE: Use AlertBox or FrostedScreen to show message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('MESSAGE'),
          content: Text('You\'re already registered in this event'),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('DISSMISS'),
            )
          ],
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ParticipateScreen(event: event),
          fullscreenDialog: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _navigatorKey = Provider.of<GlobalKey<NavigatorState>>(context);
    _bloc = EventScreenBloc(Provider.of<User>(context));
    ThemeData base = Theme.of(context);
    _teamEvent = event.team_size > 1;
    _eventType = _teamEvent ? 'Team' : 'Individual';
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // ButtonBar
            Expanded(
              flex: 1,
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    color: kColorSecondaryDark,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0))),
                    child: Text(
                      'BACK',
                      style: base.textTheme.button,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0))),
                    elevation: 12.0,
                    child: Text('REGISTER'),
                    onPressed: () {
                      participate(context);
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 9,
              child: ListView(
                children: <Widget>[
                  // Event Title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      event.event_name.toUpperCase(),
                      style: base.textTheme.display4.copyWith(fontSize: 48),
                    ),
                  ),

                  // Event Image
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                    child: Image(
                      image: AssetImage(
                          '${AssetHelper.EVENTS_LOGO}${event.imageID}.png'),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  // Divider
                  Container(
                    color: kColorSecondaryLight,
                    child: SizedBox(
                      height: 2.0,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  // Event Data
                  Container(
                    color: kColorSecondaryLight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Date and Time
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                          child: Text(
                            'On ${_getDate()} at ${_getTime()}',
                            style: base.textTheme.subhead
                                .copyWith(color: kColorTextSecondaryLight),
                          ),
                        ),

                        // Event Type
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 2.0),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  '$_eventType Event ${_teamEvent ? '(${event.team_size} per team)' : ''}',
                                  style: base.textTheme.subhead.copyWith(
                                      color: kColorTextSecondaryLight),
                                )
                              ],
                            ),
                          ),
                        ),

                        // Paid Event
                        event.is_paid
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 0.0, 8.0, 2.0),
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.attach_money,
                                        color: kColorTextPrimaryLight,
                                        size: 18,
                                      ),
                                      Text(
                                        'Fees: Rs. ${event.amount.toStringAsFixed(0)} per ${_eventType.toLowerCase()}',
                                        style: base.textTheme.subhead.copyWith(
                                            color: kColorTextSecondaryLight,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),

                        // Description
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Description:',
                            style: base.textTheme.body2
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          color: kColorSecondaryDark,
                          child: SizedBox(
                            height: 300,
                            child: Markdown(
                              data: event.description.replaceAll('\\n', '\n'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getDate() {
    String x = _dateFormat.format(event.event_schedule[0]['datetime'].toDate());
    return x;
  }

  _getTime() {
    String x = _timeFormat.format(event.event_schedule[0]['datetime'].toDate());
    return x;
  }
}
