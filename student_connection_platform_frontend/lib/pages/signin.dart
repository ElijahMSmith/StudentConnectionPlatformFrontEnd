import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:student_connection_platform_frontend/pages/signup.dart';
import 'package:student_connection_platform_frontend/pages_by_leo/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*

Defines the layout for the sign in page of the app
Users can input an email or username to the first blank and a password to the second
When the click the login button, it will validate those fields against the database
  If the credentials don't work, clear the fields and show the hidden text saying it was invalid
  If the credentials DO work, do whatever other login information is necessary and move to content page

*/

String _appName;
SharedPreferences prefs;

class SigninForm extends StatefulWidget {
  static const String routeID = '/Signin';

  SigninForm(String appName) {
    _appName = appName;
  }

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();

  // TODO: Validate against database
  bool _storeLoginInfo = false;
  String _username;
  String _password;
  bool _validationFailed = false;
  // TODO: Time out authentication attempts after x number in y amount of time
  int _loginAttempts = 0;

  _SigninFormState() {
    _getSharedPrefs();
  }

  _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _storeLoginInfo = prefs.getBool("storeLoginInfo") ?? false;
    if (_storeLoginInfo) {
      setState(() {
        _username = prefs.getString("usernameOrEmail");
        _password = prefs.getString("password");
      });
    }
  }

  bool _attemptSignin() {
    //TODO
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign in to $_appName")),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                // Welcome message
                Text('Welcome!',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),

                SizedBox(
                  height: 5,
                ),

                // Welcome description
                Text('Log in using the fields below',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),

                SizedBox(
                  height: 10,
                ),

                // Validation error text: Hidden until login attempt fail
                Visibility(
                  visible: _validationFailed,
                  child: Text(
                      'We couldn\'t find a user with that login information.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.red)),
                ),

                // Adds extra padding below error message when it shows
                Visibility(
                    visible: _validationFailed, child: SizedBox(height: 10)),

                // Username or email field - will validate against database
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) return 'Please enter your username';
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Enter your username',
                    //hintText: ''
                  ),
                  onChanged: (value) {
                    _username = value;
                  },
                ),

                SizedBox(
                  height: 24,
                ),

                // Password field - will validate against database
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) return 'Please enter a password';
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Enter your password',
                    //hintText: ''
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                ),

                SizedBox(
                  height: 24,
                ),

                // Checkbox for retaining login information for next session
                FormField(
                  initialValue: _storeLoginInfo,
                  builder: (FormFieldState formFieldState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _storeLoginInfo,
                              onChanged: (value) {
                                formFieldState.didChange(value);
                                setState(() {
                                  _storeLoginInfo = value;
                                  prefs.setBool("storeLoginInfo", value);
                                });
                              },
                            ),
                            Text(
                              'Remember my last login',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                      ],
                    );
                  },
                ),

                SizedBox(
                  height: 24,
                ),

                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                    child: Text('Log in'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () {
                      // Checks the input fields are not empty

                      // TODO: Just for now while we don't have account validation, let me into profile page easily
                      Navigator.pushNamed(context, ProfilePage.routeID);

                      var valid = _formKey.currentState.validate();
                      if (!valid) return;

                      setState(() {
                        prefs.setString("username", _username);
                        prefs.setString("password", _password);

                        _validationFailed = _attemptSignin();
                        if (!_validationFailed) {
                          //TODO: Get the account returned and move to profile page with it
                        }
                      });
                    },
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                    child: Text('Sign up'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () {
                      Navigator.pushNamed(context, SignupForm.routeID);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
