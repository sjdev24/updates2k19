import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:updates_2k19/blocs/actions_on_qr_bloc.dart';
import 'package:updates_2k19/blocs/participated_screen_bloc.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/settings/constants.dart';
import 'package:updates_2k19/utilities/operation_handling.dart';

class ActionsOnQRScreen extends StatefulWidget {
  final String qrString;

  const ActionsOnQRScreen({Key key, @required this.qrString})
      : assert(qrString != null),
        super(key: key);

  @override
  _ActionsOnQRScreenState createState() => _ActionsOnQRScreenState();
}

class _ActionsOnQRScreenState extends State<ActionsOnQRScreen> {
  String eid, uid;

  static final _iv = encrypt.IV.fromLength(16);
  static final encrypt.Encrypter _encrypter =
      encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(kKeyRandomString)));
  bool _codeHasError = false;

  final ActionsOnQRBloc _bloc = ActionsOnQRBloc();

  @override
  void initState() {
    super.initState();

    var decrypted;
    if (kRegExpOldQR.hasMatch(widget.qrString)) {
      decrypted = widget.qrString;
    } else {
      decrypted = _encrypter.decrypt64(widget.qrString, iv: _iv);
    }
    List<String> parts = decrypted.split('.');
    if (parts.length != 3) {
      _codeHasError = true;
      return;
    }
    uid = parts[1];
    eid = parts[2];
    _bloc.initialData.add(ActionableData(uid: uid, eid: eid));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData base = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: _codeHasError
            ? Center(
                child: Text('Invalid QR',
                    style: base.textTheme.display3.copyWith(
                      color: kColorPrimaryLight,
                    )),
              )
            : StreamBuilder<User>(
                stream: _bloc.userData,
                builder: (context, userSnapshot) {
                  return StreamBuilder<Event>(
                    stream: _bloc.eventData,
                    builder: (context, eventSnapshot) {
                      return StreamBuilder<Participation>(
                        stream: _bloc.participationData,
                        builder: (context, participationSnapshot) {
                          if (!(userSnapshot.hasData &&
                              eventSnapshot.hasData &&
                              participationSnapshot.hasData))
                            return Center(
                              child: Text(
                                'Processing...',
                                style: base.textTheme.display1,
                              ),
                            );
                          bool isPaidEvent = eventSnapshot.data.is_paid;
                          bool hasUserPaidFee =
                              participationSnapshot.data.data['paid'];
                          print(participationSnapshot.data.data);
                          return Container(
                            constraints: BoxConstraints.expand(),
                            color: kColorSurface,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                children: <Widget>[
                                  // Top Bar
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          'COORDINATOR ACCESS',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // User Name
                                  Text(
                                    'Name: ${userSnapshot.data.first_name} ${userSnapshot.data.last_name}',
                                    style: base.textTheme.headline,
                                  ),

                                  // Event Name
                                  Text(
                                    'Event Name: ${eventSnapshot.data.event_name}',
                                    style: base.textTheme.headline,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),

                                  // Is event paid
                                  Text(
                                    'Paid Event: ${participationSnapshot.data.data['paid'] ? 'Yes' : 'No'}',
                                    style: base.textTheme.title,
                                  ),

                                  // Paid Event Section
                                  isPaidEvent
                                      ? Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Text(
                                                'Amount: Rs. ${eventSnapshot.data.amount}',
                                                style: base.textTheme.title,
                                              ),
                                              !hasUserPaidFee
                                                  ? SizedBox(
                                                      height: 24,
                                                    )
                                                  : SizedBox(),
                                              (isPaidEvent && !hasUserPaidFee)
                                                  ? RaisedButton(
                                                      onPressed: () =>
                                                          processPayment(),
                                                      child: Text(
                                                        'MARK PAID',
                                                        style: base
                                                            .textTheme.button,
                                                      ),
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  processPayment() {
    _bloc.markPaid();
    Navigator.of(context).pop();
  }
}
