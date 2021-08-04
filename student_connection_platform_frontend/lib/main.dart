import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:student_connection_platform_frontend/Utility.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/models/matchmaker_stack.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/models/theme_provider.dart';
import 'navigator.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages_by_leo/models/account.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final String appName = "StuConn";

// Will be updated with filled version when signin or signup finishes
Account _userAccount = Account.empty();

/*
three accounts to use for testing chat functionality
dummy04 Dumdum1!
dummy05 Dumdum1!
dummy06 Dumdum1!
*/

// must call this in main or else scheduled notifications will not work
Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

// app icon by eucalyp: https://www.flaticon.com/authors/eucalyp
Future<void> main() async {
  // must call this if intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();
  runApp(AppHome());
}

class AppHome extends StatelessWidget {
  void updateAccount(Account newAccount) {
    _userAccount = newAccount;
  }

  @override
  Widget build(BuildContext context) {
    // We must have change notifier provider at the top
    // of the tree in order for this line: final users = Provider.of<Users>(context).users;
    // to work.
    return MultiProvider(
      providers: [
        // MUST BE ChangeNotifierProvider instead of Provider in order to work
        ChangeNotifierProvider<MatchMakerStack>(
          create: (_) => MatchMakerStack(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(
          context,
        );
        return MaterialApp(
          title: appName,
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          initialRoute: SigninForm.routeID,
          routes: {
            // use static strings for the route id as a way to avoid typos
            SigninForm.routeID: (context) => SigninForm(appName, this),
            SignupForm.routeID: (context) => SignupForm(appName, this),
            NavigationHelperWidget.routeID: (context) =>
                NavigationHelperWidget(_userAccount),
          },
        );
      },
    );
  }
}
