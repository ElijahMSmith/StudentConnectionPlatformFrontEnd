import 'package:flutter/material.dart';

// Once finished on signup:
// Navigator.pop(context) - pop the current page off the Navigator stack
// Navigator.pushNamed(context, '/ContentFrame');

// Allow passing back of info from each individual sigup page
// This signup.dart should add one page to stack individually and get back based on which button pressed (forwards, backwards)
// https://flutter.dev/docs/cookbook/navigation/returning-data

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
