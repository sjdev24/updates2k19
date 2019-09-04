import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/screens/components/accent_color_override.dart';
import 'package:updates_2k19/screens/components/custom_text_input.dart';
import 'package:updates_2k19/screens/components/cut_corners_border.dart';
import 'package:updates_2k19/screens/components/frosted_screen.dart';
import 'package:updates_2k19/screens/components/success_screen.dart';
import 'package:updates_2k19/screens/login_screen.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/settings/constants.dart';
import 'package:updates_2k19/settings/flare_paths.dart';
import 'package:updates_2k19/utilities/auth_helper.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';
import 'package:updates_2k19/utilities/firestore_helper.dart';
import 'package:updates_2k19/utilities/operation_handling.dart';

class UserRegistrationScreen extends StatefulWidget {
  static const String ROUTE_NAME =
      '${LoginScreen.ROUTE_NAME}/UserRegistrationScreen';

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String department;
  BuildContext _context;
  final _screenKey = GlobalKey<_UserRegistrationScreenState>();

  Map<String, dynamic> _formData = {
    'department': 'CO',
    'user_type': 0,
    'participated_in': <Map<String, String>>[],
  };

  String _emailValue = 'name@domain.com';

  String _nonEmptyValidator(String value) {
    if (value.isEmpty || value.trim().length == 0)
      return 'This field can\'t be empty';
    return null;
  }

  String _phoneValidator(String value) {
    String msg = _nonEmptyValidator(value);
    if (msg != null) return msg;
    if (!kRegExpPhone.hasMatch(value)) msg = 'Please enter valid phone number';
    return msg;
  }

  String _enrolmentValidator(String value) {
    String msg = _nonEmptyValidator(value);
    if (msg != null) return msg;
    if (!kRegExpEnrolment.hasMatch(value))
      msg = 'Please enter valid enrolment number';
    return msg;
  }

  String _emailValidation(String value) {
    String msg = _nonEmptyValidator(value);
    if (msg != null) return msg;
    if (!kRegExpEmail.hasMatch(value)) return msg = 'Invalid email';
    if (value != _emailValue) return 'Enter the same email you used to sign in';
    return msg;
  }

  String _yearValidator(String value) {
    String msg = _nonEmptyValidator(value);
    if (msg != null) return msg;
    if (!RegExp(
      "^[1-9]{1}\$",
    ).hasMatch(value)) msg = 'Please enter current year of study';
    return msg;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  GlobalKey<NavigatorState> _navigatorKey;

  @override
  Widget build(BuildContext context) {
    _getEmail(context);
    _navigatorKey = Provider.of<GlobalKey<NavigatorState>>(context);
    return WillPopScope(
      child: Scaffold(
        key: _screenKey,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Register yourself!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: Column(
                  children: <Widget>[
                    CustomTextInput(
                      label: 'First Name',
                      validator: _nonEmptyValidator,
                      onSaved: (value) {
                        _formData.addAll({'first_name': value});
                      },
                      inputType: TextInputType.text,
                    ),
                    CustomTextInput(
                      label: 'Last Name',
                      validator: _nonEmptyValidator,
                      onSaved: (value) {
                        _formData.addAll({'last_name': value});
                      },
                      inputType: TextInputType.text,
                    ),
                    CustomTextInput(
                      label: 'Enrolment No',
                      validator: _enrolmentValidator,
                      onSaved: (value) {
                        _formData.addAll({'enrolment_no': value});
                      },
                      inputType: TextInputType.number,
                    ),
                    CustomTextInput(
                      label: 'Mobile No',
                      validator: _phoneValidator,
                      onSaved: (value) {
                        _formData.addAll({'mobile_no': value});
                      },
                      inputType: TextInputType.phone,
                    ),
                    CustomTextInput(
                      validator: _emailValidation,
                      label: 'Email',
                      onSaved: (value) {
                        _formData.addAll({'email': value});
                      },
                      inputType: TextInputType.emailAddress,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: AccentColorOverride(
                        color: kColorPrimaryLight,
                        child: DropdownButtonFormField<String>(
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              child: Text('Applied Science & Humanities'),
                              value: 'ASH',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Chemical Engineering'),
                              value: 'CH',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Civil Engineering'),
                              value: 'CE',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Computer Engineering'),
                              value: 'CO',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Electrical Engineering'),
                              value: 'EE',
                            ),
                            DropdownMenuItem<String>(
                              child: Text(
                                  'Electronics & Communication Engineering'),
                              value: 'ECE',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Information Technology'),
                              value: 'IT',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Instrumentation and Control'),
                              value: 'IC',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Textile Technology'),
                              value: 'TT',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Master of Computer Application'),
                              value: 'MCA',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Mechanical Engineering'),
                              value: 'ME',
                            ),
                          ],
                          value: _formData['department'],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Department',
                            labelStyle: TextStyle(color: kColorPrimaryLight),
                            enabledBorder: CutCornersBorder(
                              borderSide: BorderSide(color: kColorPrimaryLight),
                            ),
                            fillColor: kColorSurface,
                          ),
                          onSaved: (value) {
                            setState(() {
                              _formData['department'] = value;
                            });
                          },
                          onChanged: (value) {
                            department = value;
                          },
                        ),
                      ),
                    ),
                    CustomTextInput(
                      label: 'Year',
                      validator: _yearValidator,
                      onSaved: (value) {
                        _formData.addAll({'year': int.parse(value)});
                      },
                      inputType: TextInputType.number,
                    ),
                    CustomTextInput(
                      label: 'College',
                      validator: _nonEmptyValidator,
                      onSaved: (value) {
                        _formData.addAll({'college': value});
                      },
                      inputType: TextInputType.text,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 48.0,
                child: RaisedButton(
                  child: Text(
                    'REGISTER',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    registerUser(context);
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  void registerUser(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    bool areUSure = await showDialog<bool>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
            'Check your details once again. Certificates will be issued by this name only.'
                .toUpperCase()),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('CANCEL', style: Theme.of(context).textTheme.button),
            onPressed: () => Navigator.pop(context, false),
          ),
          SimpleDialogOption(
            child: Text('REGISTER',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (areUSure == false) return;
    _formKey.currentState.save();
    await ConnectivityHelper.checkConnection(context: context);
    if (ConnectivityHelper.internetConnectivity.value ?? false) {
      var user = await AuthHelper.instance.getFirebaseUser();
      FirestoreHelper.instance.usersCollection
          .document(user.uid)
          .setData(_formData)
          .whenComplete(() {
        SharedPreferences.getInstance().then((pref) async {
          await pref.setString(kKeyTwo, user.email);
        });
      });
      Navigator.of(context)
          .push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => SuccessScreen(),
        ),
      )
          .whenComplete(() {
        SystemChrome.setEnabledSystemUIOverlays(
            [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        // DONE: Handle this bug here
        if (Navigator.of(context).canPop())
          Navigator.of(context).pop();
        else
          Navigator.of(context).pushReplacementNamed('/');
      });
    } else
      return;
  }

  void _getEmail(BuildContext context) {
    AuthHelper.instance.getFirebaseUser().then((user) {
      setState(() {
        _emailValue = user.email;
      });
    });
  }
}
