import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:updates_2k19/blocs/participated_screen_bloc.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/utilities/auth_helper.dart';
import 'package:updates_2k19/utilities/firestore_helper.dart';

class ActionableData {
  final String uid, eid;

  ActionableData({@required this.uid, @required this.eid});
}

class ActionsOnQRBloc {
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  BehaviorSubject<ActionableData> _initialDataBehaviorSubject =
      BehaviorSubject<ActionableData>();

  StreamSink<ActionableData> get initialData =>
      _initialDataBehaviorSubject.sink;

  BehaviorSubject<User> _userDataBehaviorSubject = BehaviorSubject<User>();

  ValueObservable<User> get userData => _userDataBehaviorSubject.stream;

  BehaviorSubject<Event> _eventDataBehaviorSubject = BehaviorSubject<Event>();

  ValueObservable<Event> get eventData => _eventDataBehaviorSubject.stream;

  BehaviorSubject<Participation> _participationDataBehaviorSubject =
      BehaviorSubject<Participation>();

  ValueObservable<Participation> get participationData =>
      _participationDataBehaviorSubject.stream;

  ActionsOnQRBloc() {
    _initialDataBehaviorSubject.listen((event) {
      _firestoreHelper.getUser(event.uid).then((value) {
        _userDataBehaviorSubject.add(value);
      });
      _firestoreHelper.getEvent(event.eid).then((value) {
        _eventDataBehaviorSubject.add(value);
      });
      Future<Map<String, dynamic>> participationData =
          _firestoreHelper.getParticipation(event.eid, event.uid);
      participationData.then((value) {
        _eventDataBehaviorSubject.stream.listen((data) {
          Participation p =
              Participation(_eventDataBehaviorSubject.stream.value, value);
          _participationDataBehaviorSubject.add(p);
        });
      });
    });
  }

  markPaid() {
    var t = _participationDataBehaviorSubject.stream.value;
    Map<String, dynamic> updated = t.data;
    updated['paid'] = true;
    updated['collected_by'] = AuthHelper.instance.userData.value.uid;
    _firestoreHelper.updateParticipation(
      Participation(t.e, {_userDataBehaviorSubject.stream.value.uid: updated}),
    );
  }

  markPresent() {
    var t = _participationDataBehaviorSubject.stream.value;
    Map<String, dynamic> updated = t.data;
    updated['attended'] = true;
    updated['present_marked_by'] = AuthHelper.instance.userData.value.uid;
    _firestoreHelper.updateParticipation(
      Participation(t.e, {_userDataBehaviorSubject.stream.value.uid: updated}),
    );
  }
}
