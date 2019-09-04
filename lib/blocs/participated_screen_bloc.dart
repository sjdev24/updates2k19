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
    if (_participationData != null) {
      _participationData.clear();
    } else {
      _participationData = [];
    }
    for (Map<String, String> item in participatedIn) {
      Participation value = await _getParticipation(item);
      _participationData.add(value);
      _broadcastData(_participationData);
    }
  }

  void dispose() {
//    _participationDataSubject.sink.close();
  }

  void _broadcastData(List<Participation> tempStorage) {
    _participationDataSubject.sink.add(tempStorage);
  }

  Future<Participation> _getParticipation(Map<String, String> item) async {
    Event event;
    Map<String, dynamic> data;

    event = await _firestoreHelper.getEvent(item['event_id']);
    data = await _firestoreHelper.getParticipation(
        item['event_id'], item['leader']);
    return Participation(event, data);
  }
}
