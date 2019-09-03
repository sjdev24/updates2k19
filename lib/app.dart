import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:updates_2k19/models/user.dart';
import 'package:updates_2k19/screens/about_us_screen.dart';
import 'package:updates_2k19/screens/all_events_screen.dart';
import 'package:updates_2k19/screens/backdrop.dart';
import 'package:updates_2k19/screens/components/cut_corners_border.dart';
import 'package:updates_2k19/screens/components/frosted_screen.dart';
import 'package:updates_2k19/screens/components/loading_screen.dart';
import 'package:updates_2k19/screens/home_screen.dart';
import 'package:updates_2k19/screens/login_screen.dart';
import 'package:updates_2k19/screens/navigation_menu_screen.dart';
import 'package:updates_2k19/screens/no_internet_screen.dart';
import 'package:updates_2k19/screens/participated_screen.dart';
import 'package:updates_2k19/screens/splash_screen.dart';
import 'package:updates_2k19/screens/sponsors_screen.dart';
import 'package:updates_2k19/screens/updates_team.dart';
import 'package:updates_2k19/screens/user_registration_screen.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/settings/constants.dart';
import 'package:updates_2k19/utilities/auth_helper.dart';
import 'package:updates_2k19/utilities/operation_handling.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, WidgetBuilder> _routes = {
    SplashScreen.ROUTE_NAME: (context) => SplashScreen(),
    HomeScreen.ROUTE_NAME: (context) => HomeScreen(),
    UserRegistrationScreen.ROUTE_NAME: (context) => UserRegistrationScreen(),
    AllEventsScreen.ROUTE_NAME: (context) => AllEventsScreen(),
    NoInternetScreen.ROUTE_NAME: (context) => NoInternetScreen(),
  };

  NavigationMenuItem _currentMenuItem = NavigationMenuItem.home;
  AuthHelper _authHelper = AuthHelper.instance;
  User _user;
  String _moveToNewPage;
  StatusCode _statusCode = StatusCode.PROCESSING;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var q = _authHelper.quickAuthStatus();
      q.then((code) {
        print('Status: $code');
        if (code == StatusCode.AUTH_SUCCESS) {
          if (_navigatorKey.currentState.canPop()) {
            _navigatorKey.currentState.pop();
          }
        } else if (code == StatusCode.AUTH_NOT_REGISTERED) {
          print(_moveToNewPage);
          if (_moveToNewPage == UserRegistrationScreen.ROUTE_NAME) {
            _navigatorKey.currentState
                .pushReplacementNamed(UserRegistrationScreen.ROUTE_NAME);
          } else {
            _navigatorKey.currentState.pop();
          }
        } else if (code == StatusCode.AUTH_NOT_LOGGED_IN) {
          print(_moveToNewPage);
          if (_moveToNewPage == LoginScreen.ROUTE_NAME) {
            _navigatorKey.currentState
                .pushReplacementNamed(LoginScreen.ROUTE_NAME);
          } else {
            _navigatorKey.currentState.pop();
          }
        }
        SystemChrome.setEnabledSystemUIOverlays(
            [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      });
    });
    _initiateApp();
  }

  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<User>.value(
          value: _user,
        ),
        Provider<StatusCode>.value(value: _statusCode),
        Provider<GlobalKey<NavigatorState>>.value(value: _navigatorKey),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        routes: _routes,
        initialRoute: LoadingScreen.ROUTE_NAME,
        home: Backdrop(
          backTitle: Text(
            'MENU',
            style: TextStyle(
              fontFamily: 'Montserrat',
              letterSpacing: 0.5,
            ),
          ),
          frontTitle: Text(
            kEventName.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Montserrat',
              letterSpacing: 0.5,
            ),
          ),
          frontLayer: _getFrontLayer(context, _currentMenuItem),
          backLayer: NavigationMenuScreen(
            currentMenuItem: _currentMenuItem,
            menuItems: kStudentNavigationMenuItems,
            onMenuItemTap: _onNavigationMenuItemTap,
          ),
          currentItem: NavigationMenuItem.home,
        ),
        onGenerateRoute: _getRoute,
        theme: _kUpdatesTheme,
      ),
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name == LoginScreen.ROUTE_NAME) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => LoginScreen(
          statusCode: _statusCode,
        ),
        fullscreenDialog: true,
      );
    } else if (settings.name == LoadingScreen.ROUTE_NAME) {
      return PageRouteBuilder<void>(
          pageBuilder: (BuildContext context, _, __) => LoadingScreen(),
          opaque: false);
    }
    return null;
  }

  void _onNavigationMenuItemTap(NavigationMenuItem navigationMenuItem) {
    setState(() {
      _currentMenuItem = navigationMenuItem;
    });
  }

  _getFrontLayer(BuildContext context, NavigationMenuItem currentMenuItem) {
    switch (currentMenuItem) {
      case NavigationMenuItem.home:
        return HomeScreen();
        break;
      case NavigationMenuItem.allEvents:
        return AllEventsScreen();
        break;
      case NavigationMenuItem.participated:
        return ParticipatedScreen();
        break;
      case NavigationMenuItem.sponsors:
        return SponsorsScreen();
        break;
      case NavigationMenuItem.developerTeam:
        return AboutUsScreen();
        break;
      case NavigationMenuItem.myEvent:
        // TODO: Event coordinator screen
        break;
      case NavigationMenuItem.addEvent:
        // TODO: AddEventScreen
        break;
      case NavigationMenuItem.updates2k19:
        // TODO: HeadCoordinatorScreen
        break;
      case NavigationMenuItem.updates2k19Team:
        return UpdatesTeam();
        break;
    }
  }

  _initiateApp() {
    Future<StatusCode> status = _authHelper.getAuthenticationStatus();
    status.then((value) {
      _statusCode = value;
      if (value == StatusCode.AUTH_NOT_LOGGED_IN) {
        _moveToNewPage = LoginScreen.ROUTE_NAME;
      } else if (value == StatusCode.AUTH_NOT_REGISTERED) {
        _moveToNewPage = UserRegistrationScreen.ROUTE_NAME;
      } else {
        _moveToNewPage = null;
      }
    });
    _authHelper.userData.listen((userData) {
      print('UserData: ${userData.email} ${userData.uid}');
      _user = userData;
    });
    return _user;
  }

  _disposeApp() {
    _authHelper.dispose();
  }

  _getHome(BuildContext context, StatusCode x) {
    print('_getHome StatusCode: $x');
    if (x == StatusCode.PROCESSING) {
      return FrostedScreen(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    } else if (x == StatusCode.AUTH_NOT_LOGGED_IN) {
      return LoginScreen();
    } else if (x == StatusCode.AUTH_NOT_REGISTERED) {
      return UserRegistrationScreen();
    }
  }

  _getInitialRoute(StatusCode statusCode) {
    print('_getInitialRoute StatusCode: $statusCode');
    if (statusCode == StatusCode.PROCESSING) {
      return FrostedScreen(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    } else if (statusCode == StatusCode.AUTH_NOT_LOGGED_IN) {
      return LoginScreen.ROUTE_NAME;
    } else if (statusCode == StatusCode.AUTH_NOT_REGISTERED) {
      return UserRegistrationScreen.ROUTE_NAME;
    }
  }
}

/// ThemeData
final ThemeData _kUpdatesTheme = _buildUpdatesTheme();

/// Theme
ThemeData _buildUpdatesTheme() {
  ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: kColorPrimary,
    primaryColorDark: kColorPrimaryDark,
    primaryColorLight: kColorPrimaryLight,
    accentColor: kColorSecondary,
    backgroundColor: kColorSurfaceLight,
    brightness: Brightness.dark,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: kColorPrimary,
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: kColorSurfaceDark,
    cardColor: kColorSurface,
    textSelectionColor: kColorSecondaryLight,
    // TODO: Need new error color
    errorColor: kColorSecondaryLight,
    textTheme: _buildUpdatesTextTheme(base.textTheme),
    primaryTextTheme: _buildUpdatesTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildUpdatesTextTheme(base.accentTextTheme),
    // TODO: Need new icon color
    primaryIconTheme: base.iconTheme.copyWith(color: kColorTextPrimary),
    inputDecorationTheme: InputDecorationTheme(
      border: CutCornersBorder(
        cut: 4.0,
      ), // Replace code
    ),
  );
}

/// TextTheme
TextTheme _buildUpdatesTextTheme(TextTheme textTheme) {
  return textTheme
      .copyWith(
        display4: textTheme.display4.copyWith(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w900,
          fontSize: 96.42,
          letterSpacing: -1.5,
        ),
        display3: textTheme.display3.copyWith(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 58.92,
          letterSpacing: -0.5,
        ),
        display2: textTheme.display2.copyWith(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          fontSize: 48.21,
        ),
        display1: textTheme.display1.copyWith(
          fontFamily: 'Montserrat',
          fontSize: 34.22,
          letterSpacing: 0.25,
        ),
        headline: textTheme.headline.copyWith(
          fontFamily: 'Raleway',
          fontSize: 24.34,
        ),
        title: textTheme.title.copyWith(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          fontSize: 20.24,
          letterSpacing: 0.25,
        ),
        subhead: textTheme.subhead.copyWith(
          fontFamily: 'Montserrat',
          fontSize: 16.1,
          letterSpacing: 0.15,
        ),
        body2: textTheme.body2.copyWith(
          fontFamily: 'Raleway',
          fontSize: 16.22,
          letterSpacing: 0.5,
        ),
        body1: textTheme.body1.copyWith(
          fontFamily: 'Libre Franklin',
          fontSize: 13.96,
          letterSpacing: 0.25,
        ),
        caption: textTheme.caption.copyWith(
          fontFamily: 'Montserrat',
          fontSize: 12.08,
          letterSpacing: 0.4,
        ),
        button: textTheme.button.copyWith(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          fontSize: 14.17,
          letterSpacing: 1.25,
        ),
        overline: textTheme.overline.copyWith(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          fontSize: 12.15,
          letterSpacing: 2,
        ),
        subtitle: textTheme.subtitle.copyWith(
          fontFamily: 'Raleway',
          fontSize: 14.2,
          letterSpacing: 0.1,
        ),
      )
      .apply(
        displayColor: kColorTextPrimary,
        bodyColor: kColorTextPrimaryDark,
      );
}
