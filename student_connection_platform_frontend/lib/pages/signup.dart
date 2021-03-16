import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/pages/SignupSections/AccountDetails.dart';

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
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: AccountDetails(_appName),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Backwards button
                  Image(
                    image: AssetImage('assets/images/BackwardsButton.png'),
                    width: 50,
                    height: 50,
                  ),

                  SizedBox(
                    width: 25,
                  ),

                  // Page tracker dots
                  Image(
                    image: AssetImage('assets/images/EmptyDot.png'),
                    width: 25,
                    height: 25,
                  ),

                  SizedBox(
                    width: 15,
                  ),

                  Image(
                    image: AssetImage('assets/images/FilledDot.png'),
                    width: 25,
                    height: 25,
                  ),

                  SizedBox(
                    width: 15,
                  ),

                  Image(
                    image: AssetImage('assets/images/EmptyDot.png'),
                    width: 25,
                    height: 25,
                  ),

                  SizedBox(
                    width: 25,
                  ),

                  // Forwards button
                  Image(
                    image: AssetImage('assets/images/ForwardsButton.png'),
                    width: 50,
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
