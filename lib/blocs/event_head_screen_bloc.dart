import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/utilities/firestore_helper.dart';

class EventHeadScreenBloc {
  EventHeadScreenBloc() {
    _firestoreHelper.eventsCollection.snapshots().listen((snapshot) {
      var l = snapshot.documents.map<Event>((ds) {
        ds.data.addAll({'eid': ds.documentID});
        return Event.fromJson(ds.data);
      }).toList();
      _eventDataBehaviorSubject.add(l);
    });
  }

  BehaviorSubject<List<Event>> _eventDataBehaviorSubject =
      BehaviorSubject<List<Event>>();

  ValueObservable<List<Event>> get eventData =>
      _eventDataBehaviorSubject.stream;

  FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  toggleEventAttendanceAllowance(int i) async {
    var list = _eventDataBehaviorSubject.stream.value;
    var allowAttendance = !list[i].allow_attendance;
    _firestoreHelper.eventsCollection
        .document(list[i].eid)
        .updateData({'allow_attendance': allowAttendance});
  }
}
