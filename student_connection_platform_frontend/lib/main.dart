import 'package:flutter/material.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/SignupSections/AccountDetails.dart';
import 'pages/SignupSections/UserOverview.dart';
import 'pages/SignupSections/UserDetails.dart';
import 'pages/content_frame.dart';

final String appName = "NameTBD";

void main() {
  runApp(AppHome());
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/Signin',
        routes: {
          '/Signin': (context) => SigninForm(appName),
          '/Signup/1': (context) => AccountDetails(appName),
          '/Signup/2': (context) => UserOverview(appName),
          '/Signup/3': (context) => UserDetails(appName),
          '/ContentFrame': (context) => ContentFrame(appName),
        });
  }
}
