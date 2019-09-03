import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/utilities/functions_helper.dart';

class ParticipateScreenBloc {
  User _user;

  ParticipateScreenBloc(this._user);

  Future<Map<bool, String>> participate(Event event,
      {List<String> members, String abstract}) async {
    String path;
    var data;
    if (event.team_size > 1) {
      if (event.team_size != (members.length + 1)) {
        return {false: ''};
      }
      path = FunctionsHelper.participate;
      data = {
        'uid': _user.uid,
        'partners': members,
        'abstract': abstract,
        'event_id': event.eid,
      };
    } else {
      path = FunctionsHelper.participateIndividual;
      data = {
        'user_id': _user.uid,
        'event_id': event.eid,
      };
    }

    // DONE: UserExist Validation
    String t;
    for (String s in members) {
      t = s;
      var x = await validateUser(s);
      if (x == false) {
        return {false: "$t is not registered."};
      }
    }

    var uri = Uri(
      scheme: 'https',
      host: FunctionsHelper.baseURL,
      path: path,
    );

    return http
        .post(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(data),
    )
        .then<Map<bool, String>>(
      (http.Response response) {
        if (response.statusCode == HttpStatus.ok) {
          var data = jsonDecode(response.body);
          if (data['status'] == 1)
            return {true: ''};
          else
            return {false: data['Message']};
        } else {
          return {false: 'Please try again later... ${response.statusCode}'};
        }
      },
      onError: (err) {
        return {false: err.toString()};
      },
    );
  }

  static Future<bool> validateUser(String email) async {
    if (email.trim() == "") return false;
    var data = {'mail': email.trim()};

    var uri = Uri.https(
      FunctionsHelper.baseURL,
      FunctionsHelper.isUserExist,
    );

    return http
        .post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(data),
    )
        .then<bool>((http.Response response) {
      if (response.statusCode == HttpStatus.ok) {
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }, onError: (err) {
      return false;
    });
  }
}
