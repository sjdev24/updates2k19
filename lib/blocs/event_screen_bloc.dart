import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/utilities/functions_helper.dart';

class EventScreenBloc {
  final User _user;

  EventScreenBloc(this._user);

  Future<bool> isUserRegistered(Event event) async {
    Map<String, String> data = {
      'event_id': event.eid,
      'user_id': _user.uid,
    };

    Uri uri = Uri(
        host: FunctionsHelper.baseURL,
        path: FunctionsHelper.isUserRegistered,
        scheme: 'https');

    var request = http.post(uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode(data));

    return request.then(
      (http.Response response) {
        if (response.statusCode != HttpStatus.ok) return null;
        var result = jsonDecode(response.body);
        if ((result['status'] as num) == 1)
          return true;
        else
          return false;
      },
      onError: (err) {
        print('Error $err');
        return true;
      },
    );
  }
}
