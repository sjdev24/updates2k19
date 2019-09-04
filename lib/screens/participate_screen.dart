import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:updates_2k19/blocs/participate_screen_bloc.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/screens/components/email_text_field.dart';
import 'package:updates_2k19/screens/components/loading_screen.dart';
import 'package:updates_2k19/screens/components/success_screen.dart';
import 'package:updates_2k19/screens/user_registration_screen.dart';
import 'package:updates_2k19/settings/constants.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';

class ParticipateScreen extends StatefulWidget {
  static const String ROUTE_NAME =
      '/${UserRegistrationScreen.ROUTE_NAME}/ParticipateScreen';

  final Event event;

  ParticipateScreen({this.event});

  @override
  _ParticipateScreenState createState() => _ParticipateScreenState();
}

class _ParticipateScreenState extends State<ParticipateScreen> {
  ParticipateScreenBloc _bloc;
  var _formKey = GlobalKey<FormState>();
  List<String> _memberEmails = [];
  String _abstractData;
  String _eventType;
  bool _teamEvent;
  bool _isPaid;
  GlobalKey<NavigatorState> _navigatorKey;
  User _user;

  void setupMembers() {}

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User>(context);
    _navigatorKey = Provider.of<GlobalKey<NavigatorState>>(context);
    _bloc = ParticipateScreenBloc(_user);
    _isPaid = widget.event.is_paid;
    var paidEvent = _isPaid ? Icon(Icons.attach_money) : Icon(Icons.money_off);

    _teamEvent = widget.event.team_size > 1;
    _eventType = _teamEvent ? 'Team' : 'Individual';

    var dataForm;
    List<Widget> _formFields;

    if (!_teamEvent) {
      dataForm = SizedBox();
    } else {
      _formFields = getTeamEntryForm(size: widget.event.team_size);

      if (widget.event.need_abstract)
        _formFields.add(
          TextFormField(
            maxLength: 500,
            decoration: InputDecoration(
              labelText: 'Enter Abstract',
            ),
            validator: (value) {
              if (value.isEmpty) return 'Abstract can\'t be null';
              if (value.trim().length > 150)
                return 'Abstract should be atleast of 150 characters';
              return null;
            },
            onSaved: (value) => getAbstract(value),
          ),
        );

      dataForm = Form(
        key: _formKey,
        child: Column(
          children: _formFields,
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var base = Theme.of(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Material(
                            elevation: 2.0,
                            shape: CircleBorder(),
                            child: IconButton(
                              color: Colors.red,
                              icon: Icon(
                                Icons.close,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 24.0,
                          ),
                          Text(
                            'Participate',
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 9,
                              child: Text(
                                widget.event.event_name,
                                style: base.textTheme.headline,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Expanded(flex: 1, child: paidEvent),
                          ],
                        ),
                        Text(
                          '$_eventType Event ${_teamEvent ? '(${widget.event.team_size} members per team)' : ''}',
                          style: base.textTheme.subhead,
                        ),
                        _isPaid
                            ? Text(
                                'Fess: Rs. ${widget.event.amount.toStringAsFixed(0)} per team'
                                    .toUpperCase(),
                                style: base.textTheme.subhead,
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 24.0,
                        ),
                        _teamEvent
                            ? Text(
                                'Other members\' email: ',
                                style: base.textTheme.subhead,
                              )
                            : SizedBox(),
                        _teamEvent
                            ? SizedBox(
                                height: 8,
                              )
                            : SizedBox(),
                        dataForm,
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Transform.rotate(
                            angle: pi / 4,
                            child: Material(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Transform.rotate(
                                angle: -pi / 4,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    _moveForward();
                                  },
                                  color: Colors.lightGreenAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            'PARTICIPATE',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.lightGreenAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> getTeamEntryForm({@required int size}) {
    List<Widget> form = [];
    for (int i = 0; i < (size - 1); i++) {
      form.add(
        EmailTextField(
          hint: 'Team Member Email',
          getData: (value) => retrieveData(value),
          inputDecoration: kCutsomTextInputDecoration('Team Member Email'),
        ),
      );
      form.add(
        SizedBox(
          height: 12.0,
        ),
      );
    }
    return form;
  }

  void setupForm() {}

  void retrieveData(String value) => _memberEmails.add(value);

  void getAbstract(String value) => _abstractData = value;

  Future participate() async {
    Future<Map<bool, String>> t;

//    if (widget.event.team_size > 1) {
//      if (widget.event.need_abstract) {
//        t = _bloc.participate(widget.event,
//            members: _memberEmails, abstract: _abstractData);
//      } else {
//        t = _bloc.participate(widget.event, members: _memberEmails);
//      }
//    } else {
//      if (widget.event.need_abstract)
//        t = _bloc.participate(widget.event, abstract: _abstractData);
//      else
//        t = _bloc.participate(widget.event);
//    }
    await ConnectivityHelper.checkConnection(
        context: _navigatorKey.currentContext);

    _navigatorKey.currentState.push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingScreen(),
      ),
    );
    t = _bloc.participate(
      widget.event,
      members: _memberEmails,
      abstract: _abstractData,
    );
    t.then<void>((data) {
      _navigatorKey.currentState.pop();
      if (data.containsKey(true)) {
        Navigator.of(context)
            .pushReplacement(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) => SuccessScreen(),
          ),
        )
            .whenComplete(() {
          _navigatorKey.currentState.pop();
        });
      } else if (data.containsKey(false)) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('ERROR'),
                  content: Text(data[false]),
                ));
      }
    });
  }

  void _moveForward() {
    bool isOkay = false;
    _memberEmails.clear();
    if (widget.event.team_size > 1)
      isOkay = _formKey.currentState.validate();
    else
      isOkay = true;
    if (isOkay) {
      if (widget.event.team_size > 1) _formKey.currentState.save();
      Set u = Set.from(_memberEmails);
      if (_memberEmails.contains(_user.email)) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('ERROR'),
                  content: Text('Don\'t add your email. You\'re team leader.'),
                ));
        return;
      }
      if (u.length != _memberEmails.length) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('ERROR'),
                  content: Text('All team members email should be distinct.'),
                ));
        return;
      }
      participate();
    }
    // DONE: Add done screen with green right mark
//    Navigator.of(context).pop();
  }
}
