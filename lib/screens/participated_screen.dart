import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:updates_2k19/blocs/participated_screen_bloc.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';
import 'package:updates_2k19/utilities/operation_handling.dart';

class ParticipatedScreen extends StatefulWidget {
  @override
  _ParticipatedScreenState createState() => _ParticipatedScreenState();
}

// TODO: Design this screen

class _ParticipatedScreenState extends State<ParticipatedScreen> {
  User _user;
  List<Event> _allEvents;
  ParticipatedScreenBloc _bloc;

  final _iv = encrypt.IV.fromLength(16);
  final _encrypter =
      encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(kKeyRandomString)));

  String _getEncrypted(String value) {
    encrypt.Encrypted e = _encrypter.encrypt(value, iv: _iv);
    return e.base64;
  }

  @override
  Widget build(BuildContext context) {
//    bool connStatus = ConnectivityHelper.internetConnectivity;
    return Consumer<User>(
      builder: (BuildContext context, User value, Widget child) {
        if (_bloc != null) _bloc.dispose();
        _bloc = ParticipatedScreenBloc(value);
        return StreamBuilder<List<Participation>>(
          stream: _bloc.participationData,
          builder: (BuildContext context,
              AsyncSnapshot<List<Participation>> snapshot) {
            if (snapshot == null ||
                !snapshot.hasData ||
                snapshot.data.length == 0)
              return Center(
                child: CircularProgressIndicator(
                  value: null,
                ),
              );
            return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: PageScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _getParticipationCard(snapshot, index, constraints);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox();
                },
              );
            });
          },
        );
      },
    );
  }

  _getParticipationCard(AsyncSnapshot<List<Participation>> snapshot, int index,
      BoxConstraints constraints) {
    Color qrColor = snapshot.data[index].e.is_paid
        ? (snapshot.data[index].data['paid'] ? Colors.green : Colors.red)
        : Colors.green;
    String qrEncrypted = _getEncrypted(snapshot.data[index].data['qr_string']);
//    print(snapshot.data[index].e.event_name);
//    print(qrEncrypted);
    return Container(
      constraints: BoxConstraints.expand(width: constraints.maxWidth),
      child: Card(
        child: ListView(
          children: <Widget>[
            // QR Code
            Container(
              color: Colors.white,
              child: QrImage(
                foregroundColor: qrColor,
                data: qrEncrypted,
                version: QrVersions.auto,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              snapshot.data[index].e.event_name.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: kColorTextPrimaryDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
