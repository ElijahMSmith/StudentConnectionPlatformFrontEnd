import 'package:flutter/material.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/content_frame.dart';
import 'pages_by_leo/profile_page.dart';

final String appName = "NameTBD";

void main()
{
  runApp(AppHome());
}

class AppHome extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        title: appName,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.teal,
        ),
        initialRoute: ProfilePage.routeId,
        routes:
        {
          // use static strings for the route id as a way to avoid typos
          SigninForm.routeId: (context) => SigninForm(appName),
          SignupForm.routeId: (context) => SignupForm(appName),
          ContentFrame.routeId: (context) => ContentFrame(appName),
          ProfilePage.routeId: (context) => ProfilePage(),
        });
  }
}
