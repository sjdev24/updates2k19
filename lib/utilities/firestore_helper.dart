import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:updates_2k19/blocs/participated_screen_bloc.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/models/user.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper instance = FirestoreHelper._();

  final Firestore _firestore = Firestore.instance;

  CollectionReference get usersCollection => _firestore.collection('users');

  CollectionReference get eventsCollection => _firestore.collection('events');

  CollectionReference get participantsCollection =>
      _firestore.collection('participants');

  Future<Map<String, dynamic>> getUserData(String uid) async {
    return usersCollection
        .document(uid)
        .get()
        .then((snapshot) => snapshot.data);
  }

  Future<User> getUser(String uid) {
    var ds = usersCollection.document(uid).get(source: Source.serverAndCache);
    return ds.then<User>((value) {
      value.data.addAll({'uid': value.documentID});
      return User.fromJson(value.data);
    });
  }

  Future<Event> getEvent(String eid) {
    var ds = eventsCollection.document(eid).get(source: Source.serverAndCache);
    return ds.then<Event>((value) {
      value.data.addAll({'eid': value.documentID});
      return Event.fromJson(value.data);
    });
  }

  Future<Map<String, dynamic>> getParticipation(String eid, String uid) {
    var ds =
        participantsCollection.document(eid).get(source: Source.serverAndCache);
    Future<Map> participationData = ds.then<Map<dynamic, dynamic>>((value) {
      if (value == null) {
        return null;
      }
      return value.data[uid];
    });
    return participationData.then<Map<String, dynamic>>((value) {
      return value.map<String, dynamic>((k, v) {
        return MapEntry(k as String, v);
      });
    });
  }

  void updateParticipation(Participation updated) {
    participantsCollection.document(updated.e.eid).updateData(updated.data);
  }
}
