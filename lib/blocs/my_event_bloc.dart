import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/settings/constants.dart';
import 'package:updates_2k19/utilities/firestore_helper.dart';

class MyEventBloc {
  MyEventBloc() {
    _queryBehaviorSubject.listen((query) {
      _preambleBehaviorSubject.add('Search results for: $query');
      handleQuery();
    });
  }

  FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  BehaviorSubject<String> _queryBehaviorSubject = BehaviorSubject<String>();

  StreamSink<String> get query => _queryBehaviorSubject.sink;

  BehaviorSubject<String> _preambleBehaviorSubject = BehaviorSubject<String>();

  ValueObservable<String> get preamble => _preambleBehaviorSubject.stream;

  BehaviorSubject<List<User>> _resultsBehaviorSubject =
      BehaviorSubject<List<User>>();

  ValueObservable<List<User>> get result => _resultsBehaviorSubject.stream;

  void handleQuery() {
    String query = _queryBehaviorSubject.stream.value.trim();
    if (kRegExpEmail.hasMatch(query))
      performEmailQuery();
    else if (kRegExpEnrolment.hasMatch(query))
      performEnrolmentQuery();
    else if (kRegExpPhone.hasMatch(query)) performPhoneQuery();
  }

  void performEmailQuery() {
    String query = _queryBehaviorSubject.stream.value.trim();
    _firestoreHelper.usersCollection
        .where('email', isEqualTo: query)
        .getDocuments()
        .then((querySnapshot) async {
      _addResults(querySnapshot);
    });
  }

  void performEnrolmentQuery() {
    String query = _queryBehaviorSubject.stream.value.trim();
    _firestoreHelper.usersCollection
        .where('enrolment_no', isEqualTo: query)
        .getDocuments()
        .then((querySnapshot) {
      _addResults(querySnapshot);
    });
  }

  void performPhoneQuery() {
    String query = _queryBehaviorSubject.stream.value.trim();
    _firestoreHelper.usersCollection
        .where('mobile_no', isEqualTo: query)
        .getDocuments()
        .then((querySnapshot) {
      _addResults(querySnapshot);
    });
  }

  void _addResults(QuerySnapshot querySnapshot) {
    var data = querySnapshot.documents.map<User>((document) {
      document.data.addAll({'uid': document.documentID});
      return User.fromJson(document.data);
    }).toList();
    _resultsBehaviorSubject.add(data);
  }
}
