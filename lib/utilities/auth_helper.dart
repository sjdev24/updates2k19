import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/screens/home_screen.dart';
import 'package:updates_2k19/screens/login_screen.dart';
import 'package:updates_2k19/screens/user_registration_screen.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';
import 'package:updates_2k19/utilities/operation_handling.dart';
import 'package:updates_2k19/utilities/firestore_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  AuthHelper._();

  static final AuthHelper instance = AuthHelper._();

  /// Private work variables
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  /// User data subject
  final _userDataSubject = BehaviorSubject<User>();

  /// User stream
  ValueObservable<User> get userData => _userDataSubject.stream;

  /// Function to check authentication status using SharedPreference
  Future<StatusCode> quickAuthStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String mVOne, mVTwo;
    StatusCode x;
    if (pref.containsKey(kKeyOne)) {
      mVOne = pref.getString(kKeyOne);
      if (pref.containsKey(kKeyTwo)) {
        mVTwo = pref.getString(kKeyTwo);
      }
      if (mVOne != null && mVTwo != null)
        x = StatusCode.AUTH_SUCCESS;
      else
        x = StatusCode.AUTH_NOT_REGISTERED;
    } else
      x = StatusCode.AUTH_NOT_LOGGED_IN;
    return x;
  }

  /// Return authentication status
  Future<StatusCode> getAuthenticationStatus({BuildContext context}) async {
    var user = await _auth.currentUser();
    if (user == null) {
      return Future<StatusCode>.value(StatusCode.AUTH_NOT_LOGGED_IN);
    } else {
      _auth.currentUser().then((user) {
        _firestoreHelper.usersCollection
            .document(user.uid)
            .snapshots()
            .listen((event) {
//          print('listener 2');
          var data = event.data;
          if (data == null) return;
          data.addAll({'uid': event.documentID});
          _userDataSubject.sink.add(User.fromJson(data));
        });
      });
      bool userRegStatus = await _isUserExist(user, context: context);

      if (userRegStatus) {
        _userDataSubject.sink.add(await getCurrentUser(user));
        return Future<StatusCode>.value(StatusCode.AUTH_SUCCESS);
      } else
        return Future<StatusCode>.value(StatusCode.AUTH_NOT_REGISTERED);
    }
  }

  Future<FirebaseUser> getFirebaseUser() {
    return _auth.currentUser();
  }

  /// Get user data as User object
  Future<User> getCurrentUser(FirebaseUser user) async {
    Map<String, dynamic> userData = Map<String, dynamic>();
    userData.addAll({'uid': user.uid});
    userData.addAll((await _firestoreHelper.getUserData(user.uid)));
    return User.fromJson(userData);
  }

  /// Handles Login process
  Future<String> handleSignIn() async {
    FirebaseUser user = await _auth.currentUser();

    AuthResult result;
    if (user == null) {
      result = await _handleSignIn();
      if (result == null || result.user == null) return LoginScreen.ROUTE_NAME;
      user = result.user;
      await _handleSignInPref(user);
    }

    bool isExist = await _isUserExist(user);

    _auth.currentUser().then((user) {
      _firestoreHelper.usersCollection
          .document(user.uid)
          .snapshots()
          .listen((event) {
//        print('listener 1');
        var data = event.data;
        if (data == null) return;
        data.addAll({'uid': event.documentID});
        _userDataSubject.sink.add(User.fromJson(data));
      });
    });

    if (isExist) {
      SharedPreferences.getInstance().then((pref) async {
        await pref.setString(kKeyTwo, user.email);
      });
      return HomeScreen.ROUTE_NAME;
    } else {
      return UserRegistrationScreen.ROUTE_NAME;
    }
  }

  Future _handleSignInPref(FirebaseUser user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(kKeyOne, user.uid);
  }

  /// Handles Google sign in process
  Future<AuthResult> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  /// Check if user is registered or not
  Future<bool> _isUserExist(FirebaseUser user, {BuildContext context}) async {
    var ref = _firestoreHelper.usersCollection.document(user.uid);
    if (ref == null) return Future<bool>.value(false);

    await ConnectivityHelper.checkConnection(context: context);

    return ref
        .get(source: Source.serverAndCache)
        .then((snapshot) => snapshot.exists);
  }

  /// Logout the user
  void logMeOut(BuildContext context) {
    _auth.signOut();
    _googleSignIn.signOut();
    _handleSignOutPref();
    Navigator.of(context).pushReplacementNamed(LoginScreen.ROUTE_NAME);
  }

  void _handleSignOutPref() {
    SharedPreferences.getInstance().then((pref) {
      pref.remove(kKeyOne);
      pref.remove(kKeyTwo);
    });
  }

  /// Check user login status
  Future<bool> isLoggedIn() async => (await _auth.currentUser()) != null;

  /// Dispose class
  void dispose() {
    _userDataSubject.sink.close();
  }
}
