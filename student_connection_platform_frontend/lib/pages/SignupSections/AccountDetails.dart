import 'package:student_connection_platform_frontend/pages/signup.dart';
import 'package:student_connection_platform_frontend/account.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

Account _newAccount;

class AccountDetails extends StatefulWidget {
  static String routeID = "/AccountDetails";

  AccountDetails(Account account) {
    _newAccount = account;
    initializeDateFormatting();
  }

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isValidDOB(String dob) {
    // 00/00/0000 format only
    RegExp regExp = new RegExp("^[0-9]{2}\/[0-9]{2}\/[0-9]{4}\$");

    return regExp.hasMatch(dob);
  }

  // Precon - _isValidDOB guarantees successful parsing
  bool _isValidDay(String dob) {
    int month = int.parse(dob.substring(0, 2));
    int day = int.parse(dob.substring(3, 5));
    int year = int.parse(dob.substring(6, 10));

    // More precise checking for if day of month exists and what years we accept can be done later
    if (month <= 0 || month > 12) return false;
    if (day <= 0 || day > 31) return false;
    if (year < DateTime.now().year - 120 || year > DateTime.now().year)
      return false;

    try {
      DateFormat("MM/dd/yyyy", 'en').parseStrict(dob);
    } on FormatException {
      return false;
    }

    return true;
  }

  bool _isAdult(String dob) {
    String datePattern = "MM/dd/yyyy";

    // Current time - at this moment
    DateTime today = DateTime.now();

    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(dob);

    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );

    bool _validDOB = adultDate.isBefore(today);
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
        children: <Widget>[
          // Welcome message
          SizedBox(
            height: 40,
          ),

          Text('Signup for $appName', // Defined in signup.dart
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),

          SizedBox(
            height: 40,
          ),

          // Email input field
          TextFormField(
            autofocus: true,
            initialValue: _newAccount.email,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            validator: (value) {
              if (value.isEmpty)
                return 'Please enter an email for this account.';
              _newAccount.validEmail = true;
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: 'Account email',
            ),
            onChanged: (value) {
              _newAccount.email = value;
              _newAccount.validEmail = false;
            },
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: 25,
          ),

          // Password field
          TextFormField(
            initialValue: _newAccount.password,
            obscureText: true,
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
              _newAccount.password = value;
              _newAccount.validPassword = false;
            },
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: 25,
          ),

          // Password confirmation field
          TextFormField(
              initialValue: _newAccount.password,
              obscureText: true,
              validator: (value) {
                if (value != _newAccount.password)
                  return 'Passwords don\'t match!';

                _newAccount.validPassword = true;
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: 'Confirm your password',
                //hintText: ''
              ),
              textAlign: TextAlign.center,
              onChanged: (value) {
                _newAccount.validPassword = false;
              }),

          SizedBox(
            height: 25,
          ),

          TextFormField(
            initialValue: _newAccount.dateOfBirth,
            validator: (value) {
              if (!_isValidDOB(value))
                return 'Invalid Format - Must be mm/dd/yyyy';

              if (!_isValidDay(value))
                return 'That date does not exist or is not acceptable';

              if (!_isAdult(value))
                return 'You must be at least 18 years old to sign up!';

              _newAccount.validDOB = true;

              return null;
            },
            decoration: InputDecoration(
                filled: true,
                labelText: 'Enter Your Date of Birth',
                hintText: 'mm/dd/yyyy'),
            textAlign: TextAlign.center,
            onChanged: (value) {
              _newAccount.dateOfBirth = value;
              _newAccount.validDOB = false;
            },
          ),
        ],
      ),
    ));
  }
}
