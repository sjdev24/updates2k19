import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/utilities/firestore_helper.dart';

class Participation {
  final Event e;
  final Map<String, dynamic> data;

  static const String keyQRString = 'qr_string';

  Participation(this.e, this.data);
}

class ParticipatedScreenBloc {
  FirestoreHelper _firestoreHelper = FirestoreHelper.instance;
  User _user;
  List<Participation> _participationData;

  ParticipatedScreenBloc(this._user) {
    _fetchData();
  }

  final _participationDataSubject = BehaviorSubject<List<Participation>>();

  ValueObservable<List<Participation>> get participationData =>
      _participationDataSubject.stream;

  Future _fetchData() async {
    // DONE: Participated screen data retrieval
    _participationDataSubject.sink.add(null);
    List<Map<String, String>> participatedIn = _user.participated_in;
    List<Participation> tempStorage = [];
    for (Map<String, String> item in participatedIn) {
      var event, data;
      var ds = await _firestoreHelper.eventsCollection
          .document(item['event_id'])
          .get(source: Source.serverAndCache);
      if (ds != null) {
        ds.data.addAll({'eid': ds.documentID});
        event = Event.fromJson(ds.data);
      }
      ds = await _firestoreHelper.participantsCollection
          .document(item['event_id'])
          .get(source: Source.serverAndCache);
      Map<dynamic, dynamic> dsLeader = ds[item['leader']];
      Map<String, dynamic> tempData;
      tempData = dsLeader.map<String, dynamic>((k, v) {
        return MapEntry(k as String, v);
      });

      tempStorage.add(Participation(event, tempData));
    }
    _brodcastData(tempStorage);
  }

  void dispose() {
//    _participationDataSubject.sink.close();
  }

  void _brodcastData(List<Participation> tempStorage) {
    _participationData = tempStorage;
    _participationDataSubject.sink.add(_participationData);
  }
}
