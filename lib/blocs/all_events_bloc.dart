import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/utilities/firestore_helper.dart';

class AllEventsBloc {
  FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  final _eventsDataSubject = BehaviorSubject<List<Event>>();

  ValueObservable<List<Event>> get eventsData => _eventsDataSubject.stream;

  AllEventsBloc() {
    _firestoreHelper.eventsCollection
        .getDocuments(source: Source.serverAndCache)
        .then(_fetchData);
    _firestoreHelper.eventsCollection.snapshots().listen(_fetchData);
  }

  void _fetchData(QuerySnapshot snapshot) {
    List<Event> allEvents = snapshot.documents.map((document) {
      var data = document.data;
      data['eid'] = document.documentID;
      return Event.fromJson(data);
    }).toList();

    _eventsDataSubject.sink.add(allEvents);
  }

  void dispose() {
//    _eventsDataSubject.sink.close();
  }
}
