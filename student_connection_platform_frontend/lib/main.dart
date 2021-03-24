import 'package:flutter/material.dart';
import 'pages/content_frame.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';

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
          '/Signup': (context) => SignupForm(appName),
          '/ContentFrame': (context) => ContentFrame(appName),
        });
  }
}
