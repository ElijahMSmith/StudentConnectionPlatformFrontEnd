import 'package:flutter/material.dart';

/*

Defines the layout for the sign up page for the app

Various states:
  - Initial: Holds fields for the email, password, and password confirmation
  - Second: Pick a username, add a profile picture
  - Third: Add interests, hobbies, major, etc (check 3/4 doc for full list)

*/

String _appName;

class SignupForm extends StatefulWidget {
  SignupForm(String appName) {
    _appName = appName;
  }

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
