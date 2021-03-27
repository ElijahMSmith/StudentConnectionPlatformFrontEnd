import 'package:flutter/material.dart';

/*

Defines the layout for the sign up page for the app

Various states:
  - Initial: Holds fields for the email, password, and password confirmation
  - Second: Pick a username, add a profile picture
  - Third: Add interests, hobbies, major, etc (check 3/4 doc for full list)

One option:
- Make each section its own stateful widget (in own file) and simply pick which one 
  to include in this widget (keep a counter that decides which to show, show that)
- Will need to be able to pass information back to signup (input information)
- Need forward and backward buttons to move to next or previous signup page (if possible)
    - Validate current page form data before moving, then send back to hold on
    - Need to pass in defaults from this signup widget to whatever section is shown
- If we back while on first section, simply pop this signup widget off and quit

*/

// Once finished on signup:
// Navigator.pop(context) - pop the current page off the Navigator stack
// Navigator.pushNamed(context, '/ContentFrame');

String _appName;

class SignupForm extends StatefulWidget
{
  static const String routeId = 'sign_up_form';

  SignupForm(String appName)
  {
    _appName = appName;
  }

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold();
  }
}
