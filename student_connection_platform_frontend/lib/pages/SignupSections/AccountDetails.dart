import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*

Defines the layout for the sign up page for the app

Various states:
  - AccountDetails: Holds fields for the email, password, and password confirmation
  - UserOverview: Pick a username, add a profile picture
  - UserDetails: Add interests, hobbies, major, etc (check 3/4 doc for full list)

One option:
- Make each section its own stateful widget (in own file) and simply pick which one 
  to include in this widget (keep a counter that decides which to show, show that)
- Will need to be able to pass information back to signup (input information)
- Need forward and backward buttons to move to next or previous signup page (if possible)
    - Validate current page form data before moving, then send back to hold on
    - Need to pass in defaults from this signup widget to whatever section is shown
- If we back while on first section, simply pop this signup widget off and quit

*/

String _appName;

class AccountDetails extends StatefulWidget {
  AccountDetails(String appName) {
    _appName = appName;
  }

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // After project submission, use these to validate for fields more carefully
  // For now, just make sure email/username aren't taken
  bool _invalidEmail = false;
  bool _takenEmail = false;
  bool _invalidPassword = false;

  String _email = "";
  String _password = "";
  String _dateOfBirth = "Select Your Date of Birth";

  // Whether current inputs in text fields are all valid inputs for a new account
  // Resets to false when any form field is changed, must re-submit with button to make true
  bool _validDOB = false;
  bool _validationSuccessful = false;

  bool isValidDOB(String birthDateString) {
    // 00/00/0000 format only
    RegExp regExp = new RegExp("^[0-9]{2}\/[0-9]{2}\/[0-9]{4}\$");

    return regExp.hasMatch(birthDateString);
  }

  bool isAdult(String birthDateString) {
    String datePattern = "MM/dd/yyyy";

    // Current time - at this moment
    DateTime today = DateTime.now();

    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);

    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );

    _validDOB = adultDate.isBefore(today);
    return _validDOB;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Welcome message
          SizedBox(
            height: 40,
          ),

          Text('Account Signup!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),

          SizedBox(
            height: 40,
          ),

          // Email input field
          Container(
            width: 250,
            child: TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              validator: (value) {
                if (value.isEmpty)
                  return 'Please enter an email for this account.';

                // TODO: Also validate database doesn't have this email in it already
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: 'Account email',
                //hintText: ''
              ),
              onChanged: (value) {
                _email = value;
                _validationSuccessful = false;
              },
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            height: 25,
          ),

          // Password field
          Container(
            width: 250,
            child: TextFormField(
              validator: (value) {
                //TODO: Validate password against TBD criteria
                if (value.isEmpty) return 'Please enter a password';
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: 'Choose a password',
              ),
              onChanged: (value) {
                _password = value;
                _validationSuccessful = false;
              },
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            height: 25,
          ),

          // Password confirmation field
          Container(
            width: 250,
            child: TextFormField(
              validator: (value) {
                if (value != _password) return 'Passwords don\'t match!';
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: 'Confirm your password',
                //hintText: ''
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            height: 25,
          ),

          // Date of birth field
          Container(
            width: 250,
            child: TextFormField(
              validator: (value) {
                if (!isValidDOB(value))
                  return 'Invalid Format - Must be mm/dd/yyyy';
                if (!isAdult(value))
                  return 'You must be at least 18 years old to sign up!';
                return null;
              },
              decoration: InputDecoration(
                  filled: true,
                  labelText: 'Enter Your Date of Birth',
                  hintText: 'mm/dd/yyyy'),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ));
  }
}
